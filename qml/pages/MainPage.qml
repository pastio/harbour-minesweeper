import QtQuick 2.0
import QtQuick.LocalStorage 2.0
import Sailfish.Silica 1.0
import "LocalStorage.js" as LocalStorage

Page {
    id: page


    property int wonGames : 0;
    property int playedGames : 0;
    property int bestTime : 36000;

    states: [
        State {
            name: ""
        },
        State {
            name: "flag"
        }
    ]

    function newGame(x,y,m){
        if(counter.isGameRunning()){
            mineField.playedGames++;
            console.log("mp:newgame");
            LocalStorage.saveHighScore(page, mineField)
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

        console.log("mp:newgame");
        LocalStorage.getHighScore(page, mineField);
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
                    //newGame(3,4,2);
                }
            }
            MenuItem {
                text: qsTr("New Easy")
                onClicked:{
                    newGame(6,10,10);
                    //newGame(4,3,1);
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
                    wonGames++;
                    playedGames++;

                    if(counter.time < bestTime){
                        subLabel.text = qsTr("New Time Record !!")+"\n";
                        bestTime = counter.time
                    }

                    var percentVictory = ((wonGames/playedGames)*100).toFixed(2)
                    subLabel.text += qsTr("%1% of victory in this difficulty").arg(percentVictory);

                    console.log("mp:counter:onwon");
                    LocalStorage.saveHighScore(page, mineField)
                }

                onLost: {
                    if(mainLabel.text === ""){
                        mainLabel.text=qsTr("You Lose");
                        playedGames++;

                        var percentVictory = ((wonGames/playedGames)*100).toFixed(2)
                        subLabel.text = qsTr("%1% of victory in this difficulty").arg(percentVictory);

                        console.log("mp:counter:onlost");
                        LocalStorage.saveHighScore(page, mineField)
                    }

                    else{
                        mainLabel.text=qsTr("You Lose");
                        subLabel.text = qsTr("and it's quite stupid\nbecause you were winning.");
                        wonGames--;
                        console.log("mp:mf:onexploded (apres victoire)");
                        LocalStorage.saveHighScore(page, mineField)
                    }
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
                    counter.startGame()
                }
                onExploded:{
                    counter.stopGame(false);
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
              if(counter.isGameRunning()){
                  counter.stopGame(false);
              }
          }
    }
}

