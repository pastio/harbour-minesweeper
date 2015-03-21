.pragma library
.import QtQuick.LocalStorage 2.0 as Sql

// +----------+-----+-------+-------+
// |     mode | won | total |  time |
// +----------+-----+-------+-------+
// |  6x10x10 |  2  |   7   | 12908 |
// | 12x20x30 | 12  |  23   |  9006 |
// +----------+-----+-------+-------+

function getHighScore(mineField)
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
                                   mineField.columns +'x'+
                                   mineField.preferredRows +'x'+
                                   mineField.mineNumber + '"');
            if (rs.rows.length === 1){
                mineField.wonGames = rs.rows.item(0).won;
                mineField.playedGames = rs.rows.item(0).total;
                mineField.bestTime = rs.rows.item(0).time;
            }else{
                mineField.wonGames = 0;
                mineField.playedGames = 0;
                mineField.bestTime = 36000;
            }
        }
    );
}

function saveHighScore(mineField)
{
    // Offline storage
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
                                   + mineField.columns +'x'+ mineField.preferredRows +'x'+ mineField.mineNumber + '"');
            if (rs.rows.length === 0){
                var dataInsert = [
                            mineField.columns +'x'+mineField.preferredRows +'x'+mineField.mineNumber,
                            mineField.wonGames,
                            mineField.playedGames,
                            mineField.bestTime
                ];
                tx.executeSql("INSERT INTO Scores VALUES(?, ?, ?, ?)", dataInsert);
            }else{
                var dataUpdate = [
                            mineField.wonGames,
                            mineField.playedGames,
                            mineField.bestTime,
                            mineField.columns +'x'+mineField.preferredRows +'x'+mineField.mineNumber
                ];
                tx.executeSql("UPDATE Scores SET won=?, total=?, time=? WHERE mode=?", dataUpdate);
            }
        }
    );
}

function debugPrintDB(mineField)
{
    // Offline storage
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

            console.log("##########################################")
            console.log(" mode | won | total |  time ")
            console.log(" --------------------------- ")
            console.log(" "+mineField.columns +'x'+mineField.preferredRows +'x'+mineField.mineNumber+" | " +
                        mineField.wonGames+" | " +
                        mineField.playedGames+" | " +
                        mineField.bestTime)
            console.log(" --------------------------- ")
            var rs = tx.executeSql('SELECT * FROM Scores');
            if (rs.rows.length > 0){
                for (var i = 0; i < rs.rows.length; i++) {
                    console.log(rs.rows.item(i).mode + " | " + rs.rows.item(i).won + " | " + rs.rows.item(i).total + " | " + rs.rows.item(i).time);
                }
            }
            else{
                console.log("no entries")
            }
        }
    );
}

