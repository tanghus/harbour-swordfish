/*
  Copyright (C) 2015 Thomas Tanghus <thomas@tanghus.net>
  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Jolla Ltd nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

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

import QtQuick 2.0
import Sailfish.Silica 1.0
import "pages"

ApplicationWindow {
    id: app;

    allowedOrientations: Orientation.Portrait | Orientation.Landscape;

    property alias wordnikData: frontPage.wordnikData;
    property string type: "definitions";
    property alias word: frontPage.word;
    property bool isBusy: false;
    property bool canonical: true;
    property int limit;
    property Item wordnik;

    initialPage: FrontPage {
        id: frontPage;
    }
    cover: Qt.resolvedUrl("cover/CoverPage.qml");

    Component.onCompleted: {
        loadSettings();
    }

    BusyIndicator {
        id: busyIndicator;
        anchors.centerIn: parent;
        size: BusyIndicatorSize.Large;
        running: true;
    }

    WorkerScript {
        id: wordnikScript;
        source: Qt.resolvedUrl("../js/wordnikapi.js");

        onMessage: {
            console.log("Message from WorkerScript:", messageObject.type, messageObject.wordnikData);
            if(messageObject.wordnikData !== "") {
                console.log("Setting wordnikData");
                wordnikData = messageObject.wordnikData;
            } else {
                console.log(messageObject.error);
            }
            setBusy(false);
        }
    }

    function loadSettings() {
        setBusy(true);

        canonical = settings.value("canonical", true);
        limit = settings.value("limit", 5);

        setBusy(false);
    }

    function getPayload(word, type) {
        if(isBusy) {
            return;
        }

        type = type;
        word = word;

        setBusy(true);

        wordnikScript.sendMessage({"word": word, "type": type});

    }

    function setBusy(state) {
        isBusy = state;
        busyIndicator.running = state;
    }
    function capitalize(string) {
        return string.charAt(0).toUpperCase() + string.slice(1);
    }
}


