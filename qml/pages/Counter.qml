import QtQuick 2.0
import Sailfish.Silica 1.0

Item {

    width:parent.width
    height: Theme.fontSizeLarge + 3*Theme.paddingSmall

    property int time;
    property int remainingToOpen
    property int flaggedMines;
    property int totalMines;

    property bool gamePaused:false;
    property bool gameRunning:false;

    signal won
    signal lost

    onRemainingToOpenChanged: {
        if(remainingToOpen === 0){
            stopGame(true);
        }
    }

    Label {
        id:timer
        text:time < 36000 ?
                 (("0" + parseInt(time/600)).substr(-2)) + ":" + (("0" + parseInt(time/10)%60).substr(-2)) + "." + time%10
               : qsTr("> 1 hour");
        anchors.left: parent.left;
        anchors.leftMargin: Theme.paddingLarge
        anchors.bottom: parent.bottom
        color: Theme.highlightColor

        font {
            pixelSize: Theme.fontSizeLarge
            family: Theme.fontFamilyHeading
        }

    }

    Label {
        id:flagged
        text:flaggedMines + "/" + totalMines;
        anchors.right: parent.right;
        anchors.rightMargin: Theme.paddingLarge
        anchors.bottom: parent.bottom

        color: Theme.highlightColor

        font {
            pixelSize: Theme.fontSizeLarge
            family: Theme.fontFamilyHeading
        }

    }

    Timer {
        id: gameTimer
        interval: 100
        repeat:true
        onTriggered: {
            time+=1
        }
    }

    function resetCounter(mineField){
        remainingToOpen = mineField.columns * mineField.preferredRows - mineField.mineNumber
        time = 0
        flaggedMines = 0;
        totalMines = mineField.mineNumber
        opacity=1;
    }

    function startGame(){
        gamePaused = false;
        gameRunning= true;
        gameTimer.restart()
    }

    function pauseCounter(){
        if(gameRunning && !gamePaused){
            gamePaused = true;
            console.log("pausingCounter");
            gameTimer.stop()
        }
    }

    function unpauseCounter(){
        if(gamePaused && gameRunning){
            gamePaused = false
            console.log("unpausingCounter");
            gameTimer.start()
        }
    }

    function stopGame(isGameWon){
        gamePaused = false;
        gameRunning = false;
        gameTimer.stop()
        if(isGameWon){
            won();
        }else{
            lost();
        }
    }

    function oneOpened(){
        remainingToOpen--
    }

    function oneFlagged(){
        flaggedMines++
    }

    function oneUnflagged(){
        flaggedMines--
    }

    function isGameRunning(){
        return gameRunning;
    }
}
