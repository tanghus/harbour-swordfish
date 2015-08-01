/*
  Copyright (C) 2013-2014 Marko Koschak (marko.koschak@tisno.de)
  All rights reserved.

  This file was originally part of ownKeepass:
  https://github.com/jobe-m/ownkeepass

  Minor modification by Thomas Tanghus <thomas@tanghus.net>

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

MouseArea {
    id: infoPopup

    property alias popupTitle: titleLabel.text
    property alias popupMessage: messageLabel.text

    function show(title, message, timeout) {
        popupTitle = title
        popupMessage = message
        if (timeout !== undefined) {
            _timeout = timeout * 1000
        } else {
            _timeout = 0 // set default "0" to disable timeout
        }
        if (_timeout !== 0) {
            countdown.restart()
        }
        state = "active"
    }

    function cancel() {
        _close()
        closed()
    }

    function _close() {
        if (_timeout !== 0) countdown.stop()
        state = ""
    }

    property int _timeout: 0

    signal closed

    opacity: 0.0
    visible: false
    width: parent ? parent.width : Screen.width
    height: column.height + Theme.paddingMedium * 2 + colorShadow.height
    z: 1

    onClicked: cancel()

    states: State {
        name: "active"
        PropertyChanges { target: infoPopup; opacity: 1.0; visible: true }
    }
    transitions: [
        Transition {
            to: "active"
            SequentialAnimation {
                PropertyAction { target: infoPopup; property: "visible" }
                FadeAnimation {}
            }
        },
        Transition {
            SequentialAnimation {
                FadeAnimation {}
                PropertyAction { target: infoPopup; property: "visible" }
            }
        }
    ]

    Rectangle {
        id: infoPopupBackground
        anchors.top: parent.top
        width: parent.width
        height: column.height + Theme.paddingMedium * 2
        color: Theme.highlightBackgroundColor
    }

    Rectangle {
        id: colorShadow
        anchors.top: infoPopupBackground.bottom
        width: parent.width
        height: column.height
        color: Theme.highlightBackgroundColor
    }

    OpacityRampEffect {
        sourceItem: colorShadow
        slope: 0.5
        offset: 0.0
        clampFactor: -0.5
        direction: 2 // TtB
    }

    Column {
        id: column
        x: Theme.paddingSmall + Theme.paddingMedium
        y: Theme.paddingMedium
        width: parent.width - Theme.paddingLarge - Theme.paddingSmall - Theme.paddingMedium
        height: children.height
        Label {
            id: titleLabel
            width: parent.width
            horizontalAlignment: Text.AlignLeft
            font.family: Theme.fontFamilyHeading
            font.pixelSize: Theme.fontSizeLarge
            color: "black"
            opacity: 0.6
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        }
        Label {
            id: messageLabel
            width: parent.width
            horizontalAlignment: Text.AlignLeft
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSizeExtraSmall
            color: "black"
            opacity: 0.5
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        }
    }

    Timer {
        id: countdown
        running: false
        repeat: false
        interval: _timeout

        function restart() {
            running = false
            running = true
        }

        function stop() {
            running = false
        }

        onTriggered: _close()
    }
}
