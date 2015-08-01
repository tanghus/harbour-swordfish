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
import "../components"


Page {
    id: frontPage;
    property Item resultsPage;
    property var wordnikData;
    property string coverDefinition;

    allowedOrientations: Orientation.Portrait | Orientation.Landscape;

    Component.onCompleted: {
        console.log("frontPage.onCompleted:", word);
    }

    onWordnikDataChanged: {
        console.log("FrontPage. wordnikData changed");
        if(!resultsPage) {
            resultsPage = pageStack.push(Qt.resolvedUrl("Results.qml"), {word: word, type: type});
            resultsPage.definition.connect(setCoverDefinition);
        }
        if(wordnikData) {
            resultsPage.wordnikData = wordnikData;
            // need to reset it to be sure to trigger the signal.
            wordnikData = null;
        }
    }

    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable {
        anchors.fill: parent

        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
        PullDownMenu {
            MenuItem {
                text: qsTr("About")
                onClicked: pageStack.push(Qt.resolvedUrl("About.qml"))
            }
            MenuItem {
                text: qsTr("Settings")
                onClicked: pageStack.push(Qt.resolvedUrl("Settings.qml"))
            }
        }

        PageHeader {
            id: header;
            title: "Swordfish";
        }
        SearchField {
            id: wordInput;
            anchors.top: header.bottom;
            //anchors.leftMargin: Theme.paddingLarge;
            inputMethodHints: wordPrediction
                              ? Qt.ImhNoAutoUppercase
                              : (Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText);
            placeholderText: qsTr("Enter word or phrase");
            width: parent.width; // - (2*Theme.paddingLarge);
            EnterKey.onClicked: {
                if(wordInput.text !== "") {
                    search(wordInput.text);
                }
            }
        }
        Item {
            id: searchButton;
            anchors.top: wordInput.bottom;
            anchors.topMargin: Theme.paddingLarge;
            anchors.leftMargin: Theme.paddingLarge;
            width: parent.width - (2*Theme.paddingLarge);
            Button {
                anchors.topMargin: Theme.paddingLarge;
                anchors.centerIn: parent;
                text: qsTr("Search");
                enabled: wordInput.text !== "" && !isBusy;
                onClicked: {
                    search(wordInput.text);
                }
            }
        }
    }
    WordnikLogo {}

    function search(newWord) {
        word = newWord.trim();
        console.log("Looking up:", word);
        getPayload(word, type);
    }

    function setCoverDefinition(def) {
        console.log("setCoverDefinition", def);
        coverDefinition = def;
    }
}


