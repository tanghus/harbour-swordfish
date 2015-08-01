/*
Copyright (c) 2015 Thomas Tanghus

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

// From stackoverflow.com/questions/1408289/best-way-to-do-variable-interpolation-in-javascript
function interpolate(vars, str) {
    return str.replace(/{([^{}]*)}/g,
        function (a, b) {
            var r = vars[b];
            return typeof r === 'string' || typeof r === 'number' ? r : a;
        }
    );
};

WorkerScript.onMessage = function(message) {
    console.log("In WorkerScript:", message.type, message.word);

    var urlPart;

    switch (message.type) {
        case "definitions":
        case "examples":
        case "relatedWords":
        case "pronunciations":
        case "audio":
            urlPart = "word";
            break;
        case "wotd":
        case "random":
            urlPart = "words";
            break;
    }

    var options = {
        urlPart: urlPart,
        word: encodeURIComponent(message.word),
        type: message.type,
        limit: message.limit,
        useCanonical: message.useCanonical ? "true" : "false",
        apiKey: message.apiKey
    };

    var url = "http://api.wordnik.com:80/v4/{urlPart}.json/{word}/{type}?sourceDictionaries=all&limit={limit}&useCanonical={useCanonical}&api_key={apiKey}";

    url = interpolate(options, url);

    if(message.type === "pronunciations") {
        url += "&typeFormat=gcide-diacritical"
    }

    var xhr = new XMLHttpRequest();
    xhr.timeout = 10000;

    console.log("URL", url)

    xhr.onreadystatechange = function() {
        if (xhr.readyState === XMLHttpRequest.DONE) {
            console.log('status', xhr.status, xhr.statusText)
            console.log('response', xhr.responseText)
            if(xhr.status >= 200 && xhr.status < 300) {
                var wordnikData = JSON.parse(xhr.responseText);
                if(message.type === "examples") {
                    wordnikData = wordnikData.examples;
                }

                WorkerScript.sendMessage({wordnikData: wordnikData, type: message.type});
            } else {
                WorkerScript.sendMessage({error: xhr.statusText, message: xhr.responseText});
            }
        }
    }

    xhr.ontimeout = function() {
        WorkerScript.sendMessage({error: 'Request timed out'});
    }

    xhr.open('GET', url, true);
    xhr.send();
}
