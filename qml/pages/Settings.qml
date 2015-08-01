/*
  Copyright (C) 2013 Thomas Tanghus
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

Dialog {
    id: settingsDialog;

    allowedOrientations: Orientation.Portrait | Orientation.Landscape;

    property bool tmpCanonical: canonical;
    property bool tmpWordPrediction: wordPrediction;

    SilicaFlickable {
        anchors.fill: parent;
        contentHeight: column.height;

        Column {
            id: column;
            width: parent.width;

            DialogHeader {
                id: header;
                dialog: settingsDialog;
                title: qsTr('Settings');
            }

            TextSwitch {
                id: canonicalSwitch;
                leftMargin: Theme.paddingLarge; rightMargin: Theme.paddingLarge;
                text: qsTr('Canonical');
                description: qsTr("Try to return the correct word root ('cats' -> 'cat'), or to correct a misspelled word ('flort' -> 'flirt').");
                checked: canonical;
                onCheckedChanged: {
                    tmpCanonical = checked;
                }
            }

            TextSwitch {
                id: wordPredictionSwitch;
                leftMargin: Theme.paddingLarge; rightMargin: Theme.paddingLarge;
                text: qsTr('Use word prediction');
                description: qsTr("This only makes sense if your keyboard is set to English.");
                checked: wordPrediction;
                onCheckedChanged: {
                    tmpWordPrediction = checked;
                }
            }

            Slider {
                id: limitValue;
                width: parent.width - (2*Theme.paddingLarge);
                leftMargin: Theme.paddingLarge; rightMargin: Theme.paddingLarge;
                minimumValue: 1;
                maximumValue: 50;
                stepSize: 1;
                value: limit;
                valueText: value;
                label: qsTr("Number of results to fetch");
            }
        }
    }
    onDone: {
        if(result === DialogResult.Accepted) {
            canonical = tmpCanonical;
            wordPrediction = tmpWordPrediction;
            limit = limitValue.sliderValue;
            settings.setValue("canonical", canonical);
            settings.setValue("wordPrediction", wordPrediction);
            settings.setValue("limit", limit);
        }
    }
}
