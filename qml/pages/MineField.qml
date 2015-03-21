import QtQuick 2.0
import Sailfish.Silica 1.0
import "Util.js" as Util



Grid {

    id: thisMineField
    anchors.horizontalCenter: parent.horizontalCenter
    spacing: 0

    signal opened();
    signal started();
    signal exploded();
    signal flagged();
    signal unflagged();

    property int preferredRows
    property int mineNumber

    property int wonGames : 0;
    property int playedGames : 0;
    property int bestTime : 36000;

    function closeMines() {
        for(var i = 0; i < thisMineField.children.length; i++) {
            thisMineField.children[i].state="";
        }
    }

    function deleteMines() {
        for(var i = thisMineField.children.length; i > 0 ; i--) {
          thisMineField.children[i-1].destroy()
        }
    }

    function createMines(){

        var mineComponent = Qt.createComponent("Mine.qml");
        var mine;
        var mineSize = Math.round(parent.width / columns)

        for(var j=0; j<columns*preferredRows; j++){
            mine = mineComponent.createObject(
                        thisMineField, {
                            "width": mineSize,
                            "height": mineSize,
                        }
            );
            mine.width = mineSize;
            mine.height = mineSize;
            mine.mineX = j % columns;
            mine.mineY = parseInt(j / columns);
            mine.state="untouched"
            mine.requestedValue.connect(requestedValue)
            mine.exploded.connect(explodeAll)
            mine.openedEmpty.connect(openedEmpty)
            mine.opened.connect(opened)
            mine.flagged.connect(flagged)
            mine.unflagged.connect(unflagged)
        }
    }

    function renewBoard(){
        if(thisMineField.children.length > 0){
            newFieldSequence.running=true;
        }else{
            createMines()
        }
    }

    function explodeAll(mineX, mineY, tab){
        exploded();
        for(var j=0; j<thisMineField.children.length; j++){
            thisMineField.children[j].explode();
        }
    }

    function requestedValue(mineX, mineY){
        Util.fillMinefieldNumbersFromClick(mineX, mineY, thisMineField);
        started();
    }

    function openedEmpty(mineX, mineY){
//        console.log("openedEmpty "  + mineX + " "+mineY);
        Util.openAdjacentMines(mineX, mineY, thisMineField);
    }

    SequentialAnimation {
        id:newFieldSequence
        ScriptAction {script: closeMines();}
//        PauseAnimation { duration: 2000 }
        ScriptAction {script: deleteMines();}
        ScriptAction {script: createMines();}
    }

}
