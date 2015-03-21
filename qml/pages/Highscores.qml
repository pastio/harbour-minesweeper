import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.LocalStorage 2.0 as Sql

Page {

    Column {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: Theme.paddingMedium
        anchors.rightMargin: Theme.paddingMedium

        PageHeader {
            title: qsTr("HighScores")
        }

        Label {
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: Theme.fontSizeMedium
            color: Theme.primaryColor
            text: printHighScore();
        }
    }

    function printHighScore()
    {
        // Offline storage
        var db = Sql.LocalStorage.openDatabaseSync(
            "harbour-minesweeper",
            "0.2",
            "harbour-minesweeper Local Data",
            100
        );

        var retour ="";

        db.transaction(
            function(tx) {
                tx.executeSql('CREATE TABLE IF NOT EXISTS Scores(mode TEXT PRIMARY KEY, won NUMBER, total NUMBER, time NUMBER)');
                // Only show results for the current grid size
                var rs = tx.executeSql('SELECT * FROM Scores');
                if (rs.rows.length > 0){
                    for (var i = 0; i < rs.rows.length; i++) {

                        var mode = rs.rows.item(i).mode
                        var modes = mode.split("x")
                        retour += qsTr("Game of size %1x%2 with %3 mines").arg(modes[0]).arg(modes[1]).arg(modes[2]) +"\n";

                        retour += qsTr(" - %1 game played").arg(rs.rows.item(i).total) +"\n";

                        var total = rs.rows.item(i).total;
                        if(total === 0){
                            retour += qsTr(" - No game played yet")+"\n";
                        }else{
                            var percentVictory = ((rs.rows.item(i).won/total)*100).toFixed(2)
                            retour += qsTr(" - %1% of victory in this difficulty").arg(percentVictory) +"\n";
                        }

                        var bestTime = rs.rows.item(i).time;
                        if(bestTime === 36000){
                            retour += qsTr(" - No best time yet")+"\n\n";
                        }else{
                            var bestTimeStr = (("0" + parseInt(bestTime/600)).substr(-2)) + ":" + (("0" + parseInt(bestTime/10)%60).substr(-2)) + "." + bestTime%10;
                            retour += qsTr(" - Best time of %1").arg(bestTimeStr) + "\n\n";
                        }
                    }
                }
                else{
                    retour = qsTr("no highscore yet");
                }
            }
        );

        return retour;
    }
}
