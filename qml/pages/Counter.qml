import QtQuick 2.0
import Sailfish.Silica 1.0

Item {

    id:counter

    width:parent.width
    height: Theme.fontSizeLarge + 3*Theme.paddingSmall

    property int time;
    property int remainingToOpen
    property int flaggedMines;
    property int totalMines;

    signal won

    onRemainingToOpenChanged: {
        if(remainingToOpen === 0){
            stopCounter();
            won();
        }
    }


    Label {
        id:timer


        text:(("0" + parseInt(time/600)).substr(-2)) + ":" + (("0" + parseInt(time/10)%60).substr(-2)) + ":" + time%10;
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

    function startCounter(){
        gameTimer.restart()
    }

    function pauseCounter(){
        gameTimer.stop()
    }

    function unpauseCounter(){
        gameTimer.start()
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
}
