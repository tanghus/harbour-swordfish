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
    id: resultsPage;

    allowedOrientations: Orientation.Portrait | Orientation.Landscape;

    property string type;
    property var wordnikData;

    signal definition(string definition);

    Component.onCompleted: {
        console.log("onCompleted. wordnikData:", wordnikData);
        console.log("onCompleted. word:", word);
    }

    onWordnikDataChanged: {
        console.log("results. wordnikData changed", type, wordnikData);

        for(var i = 0; i < wordnikData.length; i++) {
            if(type === "definitions" && i === 0) {
                // Check if the result is for the word queried
                // wordnik acts peculiar sometimes ;)
                if(wordnikData[i].word.toLowerCase() !== word.toLowerCase()) {
                    notifier.show(qsTr("%1 not found").arg(word), qsTr("Showing results for %1 instead").arg(wordnikData[i].word), 10);
                    word = wordnikData[i].word;
                }

                // Send string to show on cover
                console.log("Sending definition:", wordnikData[i].partOfSpeech + ": " + wordnikData[i].text);
                definition(wordnikData[i].partOfSpeech + ": " + wordnikData[i].text);
            }

            if(type === "relatedWords") {
                var words = wordnikData[i].words;
                wordnikData[i].words = "";
                for(var k = 0; k < words.length; k++) {
                    wordnikData[i].words += '<a href="' + words[k] + '">' + words[k] + "</a>";
                    if(k < words.length - 1) {
                        wordnikData[i].words += ", ";
                    }
                }

            }

            if(type === "examples") {
                wordnikData[i].title = "<style>a:link { color: " + Theme.highlightColor + "; }</style>"
                                       + '<a href="' + wordnikData[i].url + '">' + wordnikData[i].title + "</a>";
            }

            results.model.append(wordnikData[i]);
        }
    }

    ListModel {
        id: definitionsModel;
    }

    ListModel {
        id: examplesModel;
    }

    ListModel {
        id: relatedModel;
    }

    /* Disabled because of https://together.jolla.com/question/36731/cant-play-some-aac-files/?comment=103263#comment-103263
    ListModel {
        id: pronunciationsModel;
    }*/

    SilicaListView {
        id: results;
        topMargin: header.height;
        anchors.fill: parent;
        quickScroll: true;
        spacing: Theme.paddingLarge;

        header:PageHeader {
            id: pageHeader;
            state: type;
            title: qsTr("Definitions");
            description: word;
            states: [
                State {
                    name: "definitions"
                    PropertyChanges {
                        target: pageHeader;
                        title: qsTr("Definitions");
                    }
                },
                State {
                    name: "examples"
                    PropertyChanges {
                        target: pageHeader;
                        title: qsTr("Examples");
                    }
                },
                State {
                    name: "relatedWords"
                    PropertyChanges {
                        target: pageHeader;
                        title: qsTr("Related words");
                    }
                }/*,
                   Disabled because of https://together.jolla.com/question/36731/cant-play-some-aac-files/?comment=103263#comment-103263
                State {
                    name: "pronunciations"
                    PropertyChanges {
                        target: pageHeader;
                        title: qsTr("Pronunciations");
                    }
                }*/
            ]
        }

        footer: WordnikLogo { anchorBottom: false; path: "/words/" + word}

        WordnikMenu {}

        model: definitionsModel;

        delegate: Item {
            id: resultItem;
            property string attributionString;
            state: type;
            width: ListView.view.width;

            Column {
                anchors.leftMargin: Theme.paddingLarge;
                anchors.rightMargin: Theme.paddingLarge;

                //spacing: Theme.paddingLarge;
                Label {
                    id: definition;
                    visible: type === "definitions";
                    enabled: type === "definitions";
                    x: Theme.paddingLarge;
                    width: results.width - (2*Theme.paddingLarge);
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere;
                    //horizontalAlignment: Text.AlignHCenter;
                    textFormat: Text.RichText;
                    text: type === "definitions" ? index+1 + ". " + (model.partOfSpeech || "") + ": " + model.text : "";
                }
                /* Disabled because of https://together.jolla.com/question/36731/cant-play-some-aac-files/?comment=103263#comment-103263
                Row {
                    width: results.width - (2*Theme.paddingLarge);
                    spacing: Theme.paddingLarge;
                    Label {
                        id: pronunciation;
                        visible: type === "pronunciations";
                        enabled: type === "pronunciations";
                        x: Theme.paddingLarge;
                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere;
                        text: type === "pronunciations" ? model.raw : "";
                    }
                    IconButton {
                        id: audio;
                        visible: type === "pronunciations";
                        enabled: type === "pronunciations";
                        //y: Theme.paddingLarge;
                        width: Theme.fontSizeLarge;
                        height: Theme.fontSizeLarge;
                        icon.source: "image://theme/icon-l-music";
                        onClicked: {
                            console.log("Audio clicked for", word);
                            getPayload(word, "audio");
                        }
                    }
                }*/
                Column {
                    Label {
                        visible: type === "relatedWords";
                        x: Theme.paddingLarge;
                        width: results.width - (2*Theme.paddingLarge);
                        text: type === "relatedWords" ? model.relationshipType + ":" : "";
                    }
                    Label {
                        id: related
                        visible: type === "relatedWords";
                        enabled: type === "relatedWords";
                        x: Theme.paddingLarge;
                        width: results.width - (2*Theme.paddingLarge);
                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere;
                        textFormat: Text.RichText;
                        font.wordSpacing: 3;
                        lineHeight: 2;
                        lineHeightMode: Text.ProportionalHeight;
                        text: type === "relatedWords" ? "<style>a:link { color: " + Theme.highlightColor + "; }</style>"
                                                        + model.words : "";
                        onLinkActivated: {
                            console.log("Tapped:", link);
                            word = link;
                            switchType("definitions");
                        }
                    }
                }
                Column {
                    id: example;
                    spacing: Theme.paddingSmall;
                    Label {
                        visible: type === "examples";
                        enabled: type === "examples";
                        id: exampleText;
                        x: Theme.paddingLarge;
                        width: results.width - (2*Theme.paddingLarge);
                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere;
                        textFormat: Text.RichText;
                        text: type === "examples" ? model.text : "";
                    }
                    Label {
                        visible: type === "examples";
                        enabled: type === "examples";
                        id: exampleTitle;
                        x: Theme.paddingLarge;
                        width: results.width - (2*Theme.paddingLarge);
                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere;
                        font.pixelSize: Theme.fontSizeExtraSmall;
                        textFormat: Text.RichText;
                        text: type === "examples" ? model.title : "";
                        onLinkActivated: {
                            console.log("Tapped:", link);
                            Qt.openUrlExternally(link)
                        }
                    }
                }
                Attribution {
                    id: attribution;
                    x: Theme.paddingLarge;
                    width: results.width - (2*Theme.paddingLarge);
                    text: attributionString;
                }
            }
            states: [
                State {
                    name: "definitions"
                    PropertyChanges {
                        target: resultItem;
                        height: definition.height + attribution.height;
                        attributionString: model.attributionText;
                    }
                },
                State {
                    name: "examples"
                    PropertyChanges {
                        target: resultItem; height: example.height + attribution.height;
                        attributionString: model.provider.name;
                    }
                },
                State {
                    name: "relatedWords"
                    PropertyChanges {
                        target: resultItem; height: related.height + attribution.height;
                        attributionString: "";
                    }
                }/*, Disabled because of https://together.jolla.com/question/36731/cant-play-some-aac-files/?comment=103263#comment-103263
                State {
                    name: "pronunciations"
                    PropertyChanges {
                        target: resultItem; height: pronunciation.height + attribution.height;
                        attributionString: "";
                    }
                }*/
            ]
        }
    }

    function switchType(newType) {
        console.log("switchType:", newType, word);
        results.model.clear();

        var model;

        // Once a model has been populated with one type of delegates
        // it can't be changed to use another kind.
        switch(newType) {
            case "definitions":
                model = definitionsModel;
                break;
            /* Disabled because of https://together.jolla.com/question/36731/cant-play-some-aac-files/?comment=103263#comment-103263
            case "pronunciations":
                model = pronunciationsModel;
                break;
                */
            case "examples":
                model = examplesModel;
                break;
            case "relatedWords":
                model = relatedModel;
                break;
        }
        results.model = model;
        type = newType;
        getPayload(word, type);
    }
}
