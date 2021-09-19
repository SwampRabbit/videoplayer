/*
 * SPDX-FileCopyrightText: 2020 George Florea Bănuș <georgefb899@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.12

import FishUI 1.0 as FishUI

Item {
    id: control

    property alias progressBar: progressBar
    property alias footerRow: footerRow
    property alias timeInfo: timeInfo
    property alias volume: volume

    height: mainLayout.childrenRect.height + FishUI.Units.smallSpacing
    enabled: opacity !== 0
    visible: mpv.mouseY > rootWindow.height - footer.height && playList.state === "hidden"

    ShaderEffectSource {
        id: shaderEffect
        visible: true
        anchors.fill: parent
        sourceItem: mpv
        sourceRect: Qt.rect(0, 0, control.width, control.height)
    }

    FastBlur {
        visible: true
        anchors.fill: shaderEffect
        source: shaderEffect
        radius: 100
    }

    Rectangle {
        id: _background
        anchors.fill: parent
        color: FishUI.Theme.backgroundColor
        opacity: 0.7
    }

    ColumnLayout {
        id: mainLayout
        anchors.fill: parent
        anchors.topMargin: 0
        anchors.bottomMargin: FishUI.Units.smallSpacing
        spacing: FishUI.Units.smallSpacing

        HProgressBar {
            id: progressBar
            Layout.fillWidth: true
            enabled: playList.playlistView.count >= 1
        }

        RowLayout {
            id: footerRow

            Item {
                width: FishUI.Units.smallSpacing
                height: 30
            }

            Item {
                id: leftItem
                Layout.fillWidth: true
                Layout.fillHeight: true

                RowLayout {
                    anchors.fill: parent

                    Label {
                        id: timeInfo
                        text: app.formatTime(mpv.position) + " / " + app.formatTime(mpv.duration)
                        font.pointSize: 10
                        visible: playList.playlistView.count >= 1
                        Layout.alignment: Qt.AlignVCenter
                    }
                }
            }

            Item {
                id: middleItem
                Layout.preferredWidth: middleLayout.childrenRect.width
                Layout.fillHeight: true

                RowLayout {
                    id: middleLayout
                    anchors.fill: parent

                    FishUI.RoundImageButton {
                        width: 32
                        height: 32
                        iconMargins: FishUI.Units.smallSpacing
                        source: "qrc:/images/" + (FishUI.Theme.darkMode ? "dark" : "light") + "/media-skip-backward-symbolic.svg"
                        onClicked: actions.playPauseAction.triggered()
                        visible: playList.playlistView.count > 1
                    }

                    FishUI.RoundImageButton {
                        width: 32
                        height: 32
                        iconMargins: FishUI.Units.smallSpacing
                        source: mpv.pause ? "qrc:/images/" + (FishUI.Theme.darkMode ? "dark" : "light") + "/media-playback-start-symbolic.svg"
                                          : "qrc:/images/" + (FishUI.Theme.darkMode ? "dark" : "light") + "/media-playback-pause-symbolic.svg"
                        onClicked: actions.playPauseAction.triggered()
                    }

                    FishUI.RoundImageButton {
                        width: 32
                        height: 32
                        iconMargins: FishUI.Units.smallSpacing
                        source: "qrc:/images/" + (FishUI.Theme.darkMode ? "dark" : "light") + "/media-skip-forward-symbolic.svg"
                        onClicked: actions.playPauseAction.triggered()
                        visible: playList.playlistView.count > 1
                    }

//                    ToolButton {
//                        id: playPreviousFile
//                        action: actions.playPreviousAction
//                        text: ""
//                        focusPolicy: Qt.NoFocus
//                        enabled: playList.playlistView.count > 1
//                    }

//                    ToolButton {
//                        id: playPauseButton
//                        action: actions.playPauseAction
//                        text: ""
//                        icon.name: "media-playback-pause"
//                        focusPolicy: Qt.NoFocus
//                    }

//                    ToolButton {
//                        id: playNextFile
//                        action: actions.playNextAction
//                        text: ""
//                        focusPolicy: Qt.NoFocus
//                        enabled: playList.playlistView.count > 1
//                    }
                }
            }

            Item {
                id: rightItem
                Layout.fillWidth: true
                Layout.fillHeight: true

                RowLayout {
                    anchors.fill: parent
                    spacing: FishUI.Units.smallSpacing

                    Item {
                        Layout.fillWidth: true
                    }

                    FishUI.RoundImageButton {
                        id: mute
                        width: 32
                        height: 32
                        iconMargins: FishUI.Units.smallSpacing + 3
                        source: mpv.getProperty("mute") ? "qrc:/images/" + (FishUI.Theme.darkMode ? "dark" : "light") + "/audio-volume-muted-symbolic.svg"
                                                        : "qrc:/images/" + (FishUI.Theme.darkMode ? "dark" : "light") + "/audio-volume-high-symbolic.svg"
                        onClicked: {
                            mpv.setProperty("mute", !mpv.getProperty("mute"))
                            if (mpv.getProperty("mute")) {
                                mute.source = "qrc:/images/" + (FishUI.Theme.darkMode ? "dark" : "light") + "/audio-volume-muted-symbolic.svg"
                            } else {
                                mute.source = "qrc:/images/" + (FishUI.Theme.darkMode ? "dark" : "light") + "/audio-volume-high-symbolic.svg"
                            }
                        }
                    }

                    Slider {
                        id: volume
                        from: 0
                        to: 100
                        value: mpv.volume
                        implicitWidth: 100
                        implicitHeight: 25
                        wheelEnabled: true
                        leftPadding: 0
                        rightPadding: 0

                        onValueChanged: {
                            mpv.volume = value.toFixed(0)
                            // Settings.volume = value.toFixed(0)
                        }
                    }

                    Item {
                        width: 1
                    }

                    FishUI.RoundImageButton {
                        width: 32
                        height: 32
                        iconMargins: FishUI.Units.smallSpacing + 2
                        source: "qrc:/images/" + (FishUI.Theme.darkMode ? "dark" : "light") + "/list.svg"
                        onClicked: actions.togglePlaylistAction.triggered()
                    }

                    Item {
                        width: FishUI.Units.smallSpacing
                    }
                }
            }
        }
    }
}