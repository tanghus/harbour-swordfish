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

CoverBackground {
    /*CoverPlaceholder {
        text: qsTr("Look up word");
        icon.source: "image://theme/harbour-swordfish";
    }*/

    Column {
        anchors {
            fill: parent;
            leftMargin: Theme.paddingLarge;
            rightMargin: Theme.paddingLarge;
            topMargin: Theme.paddingLarge;
        }
        Label {
            text: "Swordfish";
            truncationMode: TruncationMode.Fade;
            horizontalAlignment: Text.AlignHCenter;
            width: parent.width;
            font.bold: true;
            font.pixelSize: Theme.fontSizeLarge;
        }
        Image {
            id: image;
            visible: cword.text === "";
            y: Theme.paddingLarge;
            anchors.horizontalCenter: parent.horizontalCenter
            source: "image://theme/harbour-swordfish"
        }
        Label {
            id: cword;
            text: word;
            truncationMode: TruncationMode.Fade;
            verticalAlignment: Text.AlignBottom;
            width: parent.width;
            font.pixelSize: Theme.fontSizeLarge;
        }
        Label {
            text: coverDefinition;
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere;
            verticalAlignment: Text.AlignBottom;
            width: parent.width;
            font.pixelSize: Theme.fontSizeExtraSmall;
        }
    }
}


