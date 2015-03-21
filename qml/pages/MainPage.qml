import QtQuick 2.0
import QtQuick.LocalStorage 2.0
import Sailfish.Silica 1.0
import "LocalStorage.js" as LocalStorage

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

    function newGame(x,y,m){
        if(counter.isGameOn()){
            mineField.playedGames++;
            LocalStorage.saveHighScore(mineField)
        }
        mainLabel.text=""
        subLabel.text =""
        mineField.columns=x;
        mineField.preferredRows=y;
        mineField.mineNumber = m;
        page.state = "";
        pum.highlightColor = "#FDD017"
        mineField.renewBoard()
        counter.resetCounter(mineField)
        LocalStorage.getHighScore(mineField);
    }

    SilicaFlickable {

        anchors.fill: parent

        id: flickable
        
        contentHeight: mainColumn.height

        PullDownMenu {
            id:pdm

            MenuItem {
                text: qsTr("About")
                onClicked:{
                    pageStack.push("About.qml")
                }
            }

            MenuItem {
                text: qsTr("Highscores")
                onClicked:{
                    pageStack.push("Highscores.qml")
                }
            }

            MenuItem {
                text: qsTr("New Hard")
                onClicked:{
                    newGame(12,20,30);
                }
            }
            MenuItem {
                text: qsTr("New Easy")
                onClicked:{
                    newGame(6,10,10);
                }
            }
        }

        ViewPlaceholder {
            enabled: mineField.children.length === 0
            text: qsTr("Pull down to create a new game\n\n\n\nPush up to switch between Flag an Dig")

            hintText:qsTr("The pushup menu color tells you about the mode you're in")
        }

        Column {
            id:mainColumn
            width: page.width
            anchors.centerIn: parent.center

            Counter {
                id:counter
                opacity:0;
                onWon:{
                    mainLabel.text=qsTr("You Win");
                    mineField.wonGames++;
                    mineField.playedGames++;
                    if(counter.time < mineField.bestTime){
                        subLabel.text = qsTr("New Time Record !!")+"\n";
                        mineField.bestTime = counter.time
                    }

                    var percentVictory = ((mineField.wonGames/mineField.playedGames)*100).toFixed(2)
                    subLabel.text += qsTr("%1% of victory in this difficulty").arg(percentVictory);

                    LocalStorage.saveHighScore(mineField)
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
                        mainLabel.text=qsTr("You Lose");
                        mineField.playedGames++;
                        LocalStorage.saveHighScore(mineField)

                        var percentVictory = ((mineField.wonGames/mineField.playedGames)*100).toFixed(2)
                        subLabel.text = qsTr("%1% of victory in this difficulty").arg(percentVictory);

                    }else{
                        mainLabel.text=qsTr("You Lose");
                        subLabel.text = qsTr("and it's quite stupid\nbecause you were winning.");
                        mineField.wonGames--;
                        LocalStorage.saveHighScore(mineField)
                    }
                }
            }
        }

        Column{
            id:messages
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

    onStatusChanged: {
        if(page.status === PageStatus.Active)
            counter.unpauseCounter();
        else
            counter.pauseCounter();
    }

    Connections {
          target: app
          onApplicationActiveChanged: {
              if(applicationActive)
                  counter.unpauseCounter();
              else
                  counter.pauseCounter();
          }

          Component.onDestruction: {
              if(counter.isGameOn()){
                  mineField.playedGames++;
                  LocalStorage.saveHighScore(mineField)
              }
          }
    }
}

