import QtQuick 2.0
import Sailfish.Silica 1.0
import "CeCILL.js" as License;

Page {

    Column {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: Theme.paddingMedium
        anchors.rightMargin: Theme.paddingMedium

        PageHeader {
            title: qsTr("About")
        }

        Label {
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: Theme.fontSizeMedium
            color: Theme.primaryColor
            text: qsTr("Simple minesweeper app")
        }

        Label {
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: Theme.fontSizeExtraSmall
            color: Theme.secondaryColor
            text: qsTr("Version 0.1")
        }

        Label {
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: Theme.fontSizeExtraSmall
            color: Theme.secondaryColor
            text: "Copyright © 2014 Etienne Beaumont"
        }

        Label {
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: Theme.fontSizeSmall
            color: Theme.secondaryColor
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            text: qsTr("Minesweeper is open source software licensed under the terms of ")
                  + qsTr("the CeCILL License.")
        }

        Button {
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("View license in English")
            onClicked: {
                pageStack.push(Qt.resolvedUrl("License.qml"), {"isEn": true});
            }
        }

        Button {
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("View license in French")
            onClicked: {
                pageStack.push(Qt.resolvedUrl("License.qml"), {"isEn": false});
            }
        }
    }

}
