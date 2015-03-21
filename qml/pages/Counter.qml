import QtQuick 2.0
import Sailfish.Silica 1.0

Item {

    width:parent.width
    height: Theme.fontSizeLarge + 3*Theme.paddingSmall

    property int time;
    property int remainingToOpen
    property int flaggedMines;
    property int totalMines;

    property bool paused:false;

    signal won

    onRemainingToOpenChanged: {
        if(remainingToOpen === 0){
            stopCounter();
            won();
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
        paused = false
        gameTimer.stop()
    }

    function startCounter(){
        paused = false
        gameTimer.restart()
    }

    function pauseCounter(){
        if(counter.time > 0){
            paused = true;
            console.log("pausingCounter");
            gameTimer.stop()
        }
    }

    function unpauseCounter(){
        if(paused){
            paused = false
            console.log("unpausingCounter");
            gameTimer.start()
        }
    }

    function stopCounter(){
        gameTimer.stop()
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

    function isGameOn(){
        if(counter.time>0){
            return true
        }
        return false
    }
}
