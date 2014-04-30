import QtQuick 2.0
import Sailfish.Silica 1.0
//import QtFeedback 5.0 //When will that be supported ?

Item {


    id: thisMine

    property bool isExploded:false;

    property int adjacentMinesCount : -1;
    property int mineX : 0;
    property int mineY : 0;

    signal exploded(int x, int y)
    signal requestedValue(int x, int y)
    signal openedEmpty(int x, int y)

    signal opened()
    signal flagged()
    signal unflagged()

    GlassItem {
        id:thisGlassItem
        anchors.fill: parent
        dimmed: !true
        cache: true
        falloffRadius: 0.13
        opacity:0
    }

    Label {
        id:thisNumber
        anchors.fill: parent
        color:{
            adjacentMinesCount == 9 ? "red" : Theme.highlightColor;
        }
        font.family: Theme.fontFamilyHeading
        text:{
              adjacentMinesCount == 9 ? "M" :
                                 adjacentMinesCount == 0 ? " " :
                                                     adjacentMinesCount ;
        }
        horizontalAlignment:Text.AlignHCenter;
        verticalAlignment:Text.AlignVCenter;
        opacity:0
    }

    function explode(tab){
        if(!isExploded){
            isExploded = true;
            state = 'opened';
        }
    }

    function openEmpty(){
        state = 'opened';
    }
/*
    HapticsEffect {
        id: rumbleEffect
        attackIntensity: 0.0
        attackTime: 250
        intensity: 1.0
        duration: 400
        fadeTime: 250
        fadeIntensity: 0.0
    }
*/
    states: [
        State {
            name: "" //nothing
            PropertyChanges { target: thisGlassItem; opacity: 0;}
            PropertyChanges { target: thisNumber; opacity: 0;}
        },
        State {
            name: "untouched"
            PropertyChanges { target: thisGlassItem; color: "white";falloffRadius: 0.13; opacity: 1;}
            PropertyChanges { target: thisNumber; opacity: 0;}
        },
        State {
            name: "flagged"
            PropertyChanges { target: thisGlassItem; color: "red"; falloffRadius: 0.12; opacity: 1;}
            PropertyChanges { target: thisNumber; opacity: 0;}
        },
        State {
            name: "opened"
            PropertyChanges { target: thisGlassItem; opacity: 0;}
            PropertyChanges { target: thisNumber; opacity: 1;}
            StateChangeScript {
                name: "triggerOpeningSignals"
                script: {
                    if(!isExploded)
                    {
                        if(adjacentMinesCount == 9){
                            isExploded = true
                            thisMine.exploded(mineX, mineY);
                            //rumbleEffect.start();
                        }else{
                            if(adjacentMinesCount == -1){
                                thisMine.requestedValue(mineX, mineY);
                            }
                            if(adjacentMinesCount == 0){
                                thisMine.openedEmpty(mineX, mineY)
                            }
                            opened();
                        }
                    }
                }
            }
        }
    ]

    MouseArea {
        anchors.fill: parent
        onClicked: {
            if(page.state === ''){//page: dig
                if(thisMine.state === 'untouched'){
                    thisMine.state = 'opened'
                }else if(thisMine.state === 'flagged'){
                    thisMine.state = 'untouched';
                }
            }else{//page:flag
                if(thisMine.state === 'untouched'){
                    thisMine.state = 'flagged'
                }else if(thisMine.state === 'flagged'){
                    thisMine.state = 'untouched';
                }
            }
        }
    }

    transitions:[
        Transition {
            from: ""; to:"untouched";
            ParallelAnimation {
                NumberAnimation {target: thisGlassItem; property: "opacity"; easing.type: Easing.Linear; duration: 500 }
            }
        },
        Transition {
            from: "untouched"; to: "flagged";
            ParallelAnimation {
                ColorAnimation {target: thisGlassItem;  easing.type: Easing.Linear; duration: 250 }

                SequentialAnimation {
                    loops: Animation.Infinite
                    NumberAnimation {target: thisGlassItem; property: "falloffRadius"; to: 0.15; easing.type: Easing.OutBounce; duration: 500 }
                    NumberAnimation {target: thisGlassItem; property: "falloffRadius"; to: 0.1; easing.type: Easing.OutQuad; duration: 500 }
                }

                ScriptAction {
                    script: {
                        flagged();
                    }
                }
            }
        },
        Transition {
            from: "flagged"; to: "untouched";
            ParallelAnimation {
                ColorAnimation { target: thisGlassItem; easing.type: Easing.Linear; duration: 250 }
                NumberAnimation {target: thisGlassItem; property: "falloffRadius"; to: 0.13; easing.type: Easing.Linear; duration: 250 }
                NumberAnimation {target: thisNumber; property: "opacity"; easing.type: Easing.Linear; duration: 500 }
            }

            ScriptAction {
                script: {
                    unflagged();
                }
            }
        },
        Transition {
            to: "opened";
            ParallelAnimation {
                NumberAnimation {target: thisGlassItem; property: "opacity"; easing.type: Easing.Linear; duration: 500 }
                NumberAnimation {target: thisNumber; property: "opacity"; easing.type: Easing.Linear; duration: 500 }
            }
        },
        Transition {
            to:"";
            SequentialAnimation {
                ScriptAction { scriptName: "triggerOpeningSignals" }
                ParallelAnimation {
                    NumberAnimation {target: thisGlassItem; property: "opacity"; to:0; easing.type: Easing.Linear; duration: 500 }
                    NumberAnimation {target: thisNumber; property: "opacity"; to:1; easing.type: Easing.Linear; duration: 500 }
                }

                PauseAnimation { duration: 3000 }

                ParallelAnimation {
                    NumberAnimation {target: thisNumber; property: "opacity"; to:0; easing.type: Easing.Linear; duration: 500 }
                }
            }
        }
    ]
}
