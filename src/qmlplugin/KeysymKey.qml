// SPDX-FileCopyrightText: 2025 Devin Lin <devin@kde.org>
// SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.VirtualKeyboard

import org.kde.kirigami as Kirigami

// Key component for our own keyboard simulator keys (ex. Meta, Alt, Ctrl, Esc)
BaseKey {
    id: keyPanel

    property var theme: BreezeConstants

    // Whether this key is "pressed" as a modifier (ex. Meta, Alt, Ctrl)
    property bool checked: false

    // The icon to use (as opposed to text)
    property string iconSource

    keyType: QtVirtualKeyboard.KeyType.Key
    functionKey: true

    keyPanelDelegate: BreezeKeyPanel {
        Item {
            id: keyContent

            QQC2.Label {
                id: keyText
                text: control.displayText
                color: theme.keyTextColor
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: control.displayText.length > 1 ? Text.AlignVCenter : Text.AlignBottom
                anchors.centerIn: parent
                TextMetrics {
                    id: keyTextMetrics
                    text: keyText.text
                    font.family: theme.fontFamily
                    font.weight: Font.Light
                    font.pixelSize: 40 * theme.scaleHint
                    font.capitalization: Font.MixedCase
                }
                font {
                    family: theme.fontFamily
                    weight: Font.Light
                    pixelSize: {
                        const baseSize = 40 * theme.scaleHint;
                        const width = keyTextMetrics.width;
                        const contentWidth = control.width - (theme.keyBackgroundMargin * 2);
                        const target = contentWidth * 0.9;
                        if (!width || width <= 0 || !target || target <= 0) {
                            return baseSize;
                        }
                        const ratio = Math.min(1.0, target / width);
                        return baseSize * ratio;
                    }
                    capitalization: Font.MixedCase
                }
            }

            Kirigami.Icon {
                id: icon
                source: keyPanel.iconSource
                anchors.centerIn: parent
                implicitHeight: 88 * theme.keyIconScale
                implicitWidth: implicitHeight
                visible: keyPanel.iconSource.length > 0
            }
        }

        states: [
            State {
                name: "disabled"
                when: !control.enabled
                PropertyChanges {
                    target: keyContent
                    opacity: 0.75
                }
                PropertyChanges {
                    target: keyText
                    opacity: 0.05
                }
            }
        ]
    }
}
