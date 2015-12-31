.pragma library
.import QtQuick.LocalStorage 2.0 as Sql

// +----------+-----+-------+-------+
// |     mode | won | total |  time |
// +----------+-----+-------+-------+
// |  6x10x10 |  2  |   7   | 12908 |
// | 12x20x30 | 12  |  23   |  9006 |
// +----------+-----+-------+-------+

var db = "";

function openDb(){
    // Offline storage
    console.log("openDB");

    var db = Sql.LocalStorage.openDatabaseSync(
        "harbour-minesweeper",
        "0.2",
        "harbour-minesweeper Local Data",
        100
    );
}

function resetDb(){

    var db = Sql.LocalStorage.openDatabaseSync(
        "harbour-minesweeper",
        "0.2",
        "harbour-minesweeper Local Data",
        100
    );

    db.transaction(
        function(tx) {
            tx.executeSql('DROP TABLE Scores');
        }
    );

}

function printHighScore()
{
    console.log("printHighScore");

    var retour ="";


    var db = Sql.LocalStorage.openDatabaseSync(
        "harbour-minesweeper",
        "0.2",
        "harbour-minesweeper Local Data",
        100
    );

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

function getHighScore(page, minefield)
{

    var db = Sql.LocalStorage.openDatabaseSync(
        "harbour-minesweeper",
        "0.2",
        "harbour-minesweeper Local Data",
        100
    );

    db.transaction(
        function(tx) {
            tx.executeSql('CREATE TABLE IF NOT EXISTS Scores(mode TEXT PRIMARY KEY, won NUMBER, total NUMBER, time NUMBER)');
            // Only show results for the current grid size

            var rs = tx.executeSql('SELECT * FROM Scores WHERE mode = "' +
                                   minefield.columns +'x'+
                                   minefield.preferredRows +'x'+
                                   minefield.mineNumber + '"');
            if (rs.rows.length === 1){
                page.wonGames = rs.rows.item(0).won;
                page.playedGames = rs.rows.item(0).total;
                page.bestTime = rs.rows.item(0).time;
            }else{
                page.wonGames = 0;
                page.playedGames = 0;
                page.bestTime = 36000;
            }
        }
    );
    console.log("getHighScore " +page.wonGames + " " + page.playedGames + " " + page.bestTime);

//    console.log("######################################");
//    console.log("getHighScore");
//    debugPrintDB(mineField);
//    console.log("######################################");
}

function saveHighScore(page, minefield)
{
    console.log("saveHighScore " +page.wonGames + " " + page.playedGames + " " + page.bestTime);

    var db = Sql.LocalStorage.openDatabaseSync(
        "harbour-minesweeper",
        "0.2",
        "harbour-minesweeper Local Data",
        100
    );

    db.transaction(
        function(tx) {
            tx.executeSql('CREATE TABLE IF NOT EXISTS Scores(mode TEXT PRIMARY KEY, won NUMBER, total NUMBER, time NUMBER)');

            var rs = tx.executeSql('SELECT * FROM Scores WHERE mode = "'
                                   + minefield.columns +'x'
                                   + minefield.preferredRows +'x'
                                   + minefield.mineNumber + '"');
            if (rs.rows.length === 0){
                var dataInsert = [
                            minefield.columns +'x'+minefield.preferredRows +'x'+minefield.mineNumber,
                            page.wonGames,
                            page.playedGames,
                            page.bestTime
                ];
                tx.executeSql("INSERT INTO Scores VALUES(?, ?, ?, ?)", dataInsert);
            }else{
                var dataUpdate = [
                            page.wonGames,
                            page.playedGames,
                            page.bestTime,
                            minefield.columns +'x'+minefield.preferredRows +'x'+minefield.mineNumber
                ];
                tx.executeSql("UPDATE Scores SET won=?, total=?, time=? WHERE mode=?", dataUpdate);
            }
        }
    );

//    console.log("######################################");
//    console.log("saveHighScore");
//    debugPrintDB(mineField);
//    console.log("######################################");
}

//function debugPrintDB(mineField)
//{

//    var db = Sql.LocalStorage.openDatabaseSync(
//        "harbour-minesweeper",
//        "0.2",
//        "harbour-minesweeper Local Data",
//        100
//    );

//    db.transaction(
//        function(tx) {
//            tx.executeSql('CREATE TABLE IF NOT EXISTS Scores(mode TEXT PRIMARY KEY, won NUMBER, total NUMBER, time NUMBER)');
//            // Only show results for the current grid size

//            console.log("##########################################")
//            console.log(" mode | won | total |  time ")
//            console.log(" --------------------------- ")
//            var rs = tx.executeSql('SELECT * FROM Scores');
//            if (rs.rows.length > 0){
//                for (var i = 0; i < rs.rows.length; i++) {
//                    console.log(rs.rows.item(i).mode + " | " + rs.rows.item(i).won + " | " + rs.rows.item(i).total + " | " + rs.rows.item(i).time);
//                }
//            }
//            else{
//                console.log("no entries")
//            }
//        }
//    );
//}

