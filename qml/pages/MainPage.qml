import QtQuick 2.0
import QtQuick.LocalStorage 2.0
import Sailfish.Silica 1.0

Page {
    id: page

    states: [
        State {
            name: ""
        },
        State {
            name: "flag"
        }
    ]

    SilicaFlickable {

        anchors.fill: parent

        id: flickable
        
        contentHeight: column.height

        PullDownMenu {
            id:pdm

            MenuItem {
                text: qsTr("About")
                onClicked:{
                    counter.pauseCounter();
                    var about = pageStack.push("About.qml")
                    about.onStatusChanged.connect(function() {
                        if(about.status === PageStatus.Inactive)
                            counter.unpauseCounter();
                    })
                }
            }

            MenuItem {
                text: qsTr("New Hard")
                onClicked:{
                    mainLabel.text=""
                    subLabel.text =""
                    mineField.columns=12;
                    mineField.preferredRows=20;
                    mineField.mineNumber = 30;
                    page.state = "";
                    pum.highlightColor = "#FDD017"
                    mineField.renewBoard()
                    counter.resetCounter(mineField)
                }
            }
            MenuItem {
                text: qsTr("New Easy")
                onClicked:{
                    mainLabel.text=""
                    subLabel.text =""
                    mineField.columns=6;
                    mineField.preferredRows=10;
                    mineField.mineNumber = 10;
                    page.state = "";
                    pum.highlightColor = "#FDD017"
                    mineField.renewBoard()
                    counter.resetCounter(mineField)
                }
            }
        }

        ViewPlaceholder {
            enabled: mineField.children.length === 0
            text: qsTr("Pull down to create a new game



Push up to switch between Flag an Dig")

            hintText:qsTr("The pushup menu color tells you about the mode you're in")
        }


        Column{
            anchors.centerIn: parent
            Label{
                width: page.width
                id:mainLabel
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: Theme.fontSizeHuge
                color: Theme.primaryColor
                text:""
            }

            Label{
                width: page.width
                id:subLabel
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: Theme.fontSizeLarge
                color: Theme.primaryColor
                text:""
            }
        }

        Column {
            id:column
            width: page.width
            anchors.centerIn: parent.center


            Counter {
                id:counter
                opacity:0;
                onWon:{
                    mainLabel.text=qsTr("You Win");
                    console.log("won")
                }
            }

            MineField{
                id:mineField;
                onOpened:{
                    counter.oneOpened()
                }
                onFlagged:{
                    counter.oneFlagged()
                }
                onUnflagged:{
                    counter.oneUnflagged()
                }
                onStarted:{
                    counter.startCounter()
                }
                onExploded:{
                    counter.stopCounter()
                    if(mainLabel.text === ""){
                        mainLabel.text=qsTr("You Loose");
                    }else{
                        mainLabel.text=qsTr("You Loose");
                        subLabel.text = qsTr("and it's quite stupid
because you were winning");
                    }
                }
            }
        }

        PushUpMenu{
            id:pum
            highlightColor:"#FDD017"


            MenuItem {
                id:pummi
                text:(page.state  == '') ? qsTr("Flag") : qsTr("Dig")
                onClicked:{
                    if(page.state  == ''){
                        pummi.text = qsTr("Dig")
                        pum.highlightColor = "red"
                        page.state = "flag"
                    }else{
                        pummi.text = qsTr("Flag")
                        pum.highlightColor = "#FDD017"
                        page.state = ""
                    }
                }
            }

        }
    }
}

