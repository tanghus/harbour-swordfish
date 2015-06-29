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
import "../components"

Page {
    id: resultsPage;

    allowedOrientations: Orientation.Portrait | Orientation.Landscape;

    property string word;
    property string type;
    property var wordnikData;

    Component.onCompleted: {
        console.log("onCompleted. wordnikData:", wordnikData);
        console.log("onCompleted. word:", word);
        getPayload(word, type);
    }

    onWordnikDataChanged: {
        console.log("results. wordnikData changed", type, wordnikData);
        for(var i = 0; i < wordnikData.length; i++) {
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

    SilicaListView {
        id: results;
        topMargin: header.height; bottomMargin: logo.height*2;
        anchors.fill: parent;
        quickScroll: true;
        spacing: Theme.paddingLarge;

        header:PageHeader {
            id: pageHeader;
            state: type;
            title: qsTr("Definitions");
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
                    name: "related"
                    PropertyChanges {
                        target: pageHeader;
                        title: qsTr("Related");
                    }
                }
            ]
        }

        WordnikMenu {}

        model: definitionsModel;

        delegate: ListItem {
            id: resultItem;
            property string attributionString;
            anchors.bottomMargin: logo.height*2;
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
                    text: type === "definitions" ? index+1 + ". " + model.partOfSpeech + ": " + model.text : "";
                }
                Label {
                    id: related
                    visible: type === "related";
                    enabled: type === "related";
                    x: Theme.paddingLarge;
                    width: results.width - (2*Theme.paddingLarge);
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere;
                    text: type === "related" ? model.relationshipType + ": " + model.words : "";
                }
                Column {
                    id: example;
                    spacing: Theme.paddingSmall;
                    Label {
                        visible: type === "examples";
                        enabled: type === "examples";
                        id: exampleTitle;
                        x: Theme.paddingLarge;
                        width: results.width - (2*Theme.paddingLarge);
                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere;
                        textFormat: Text.RichText;
                        text: type === "examples" ? model.title : "";
                    }
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
                    name: "related"
                    PropertyChanges {
                        target: resultItem; height: related.height + attribution.height;
                        attributionString: "";
                    }
                }
            ]
        }
    }
    WordnikLogo { id: logo; path: "/words/" + word}

    function switchType(newType) {
        console.log("switchType:", newType)
        results.model.clear();

        var model;

        switch(newType) {
            case "definitions":
                model = definitionsModel;
                break;
            case "examples":
                model = examplesModel;
                break;
            case "related":
                model = relatedModel;
                break;
        }
        results.model = model;
        type = newType;
        getPayload(word, type);
    }
}
