import QtQuick 2.0
import Sailfish.Silica 1.0
import "LocalStorage.js" as LocalStorage

Page {
    SilicaFlickable {

        anchors.fill: parent
        contentHeight: column.height

        Column {
            id:column
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: Theme.paddingMedium
            anchors.rightMargin: Theme.paddingMedium
            spacing: 10

            PageHeader {
                title: qsTr("HighScores")
            }

            Label {
                id:highscores
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: Theme.fontSizeMedium
                color: Theme.primaryColor
                text: LocalStorage.printHighScore();
            }

            RemorsePopup { id: remorse }

            Button {
                text: qsTr("Reset High Scores")
                anchors.horizontalCenter : parent.horizontalCenter
                onClicked: remorse.execute(qsTr("Resetting"), function(){
                    LocalStorage.resetDb();
                    highscores.text=LocalStorage.printHighScore();
                })
            }
        }
    }
}
