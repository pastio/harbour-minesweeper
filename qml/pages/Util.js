.pragma library

function fillMinefieldNumbersFromClick(xClic, yClic, currentMineField){
    //    console.log("filling with " + xClic +" "+yClic);

    //fill with cross
    for (var i = 0; i < currentMineField.mineNumber; i++) {
        var aleaX = Math.floor(Math.random()*currentMineField.columns);
        var aleaY = Math.floor(Math.random()*currentMineField.preferredRows);
        //        console.log("trying with x=" + aleaX +" y="+aleaY);
        if(currentMineField.children[aleaY*currentMineField.columns + aleaX].adjacentMinesCount === 9){
            i--;
            //            console.log("   already in ");
        }
        else if(aleaX>=(xClic-1)
                && aleaX<=(xClic+1)
                && aleaY>=(yClic-1)
                && aleaY<=(yClic+1))
        {
            i--;
            //            console.log("   too close");
        }
        else{
            currentMineField.children[(aleaY*currentMineField.columns + aleaX)].adjacentMinesCount = 9;
            //            console.log("   setting " );
        }
    }

    //fill with rest
    for(var y=0; y<currentMineField.preferredRows; y++){
        for(var x=0; x<currentMineField.columns; x++){
            if(currentMineField.children[y*currentMineField.columns + x].adjacentMinesCount !== 9){
                var nb = 0;

                //for each case around ours, add one if isMine
                if(y>0 && x>0)
                    if(currentMineField.children[(y-1)*currentMineField.columns + x - 1].adjacentMinesCount===9)
                        nb++;

                if(y>0)
                    if(currentMineField.children[(y-1)*currentMineField.columns + x].adjacentMinesCount===9)
                        nb++;

                if(y>0 && x<(currentMineField.columns-1))
                    if(currentMineField.children[(y-1)*currentMineField.columns + x + 1].adjacentMinesCount===9)
                        nb++;

                if(x>0)
                    if(currentMineField.children[y*currentMineField.columns + x - 1].adjacentMinesCount===9)
                        nb++;

                if(x<(currentMineField.columns-1))
                    if(currentMineField.children[y*currentMineField.columns + x + 1].adjacentMinesCount===9)
                        nb++;

                if(y<(currentMineField.preferredRows-1) && x>0)
                    if(currentMineField.children[(y+1)*currentMineField.columns + x - 1].adjacentMinesCount===9)
                        nb++;

                if(y<(currentMineField.preferredRows-1))
                    if(currentMineField.children[(y+1)*currentMineField.columns + x].adjacentMinesCount===9)
                        nb++;

                if(y<(currentMineField.preferredRows-1) && x<(currentMineField.columns-1))
                    if(currentMineField.children[(y+1)*currentMineField.columns + x + 1].adjacentMinesCount===9)
                        nb++;

                currentMineField.children[y*currentMineField.columns + x].adjacentMinesCount = nb;
                //                console.log("setting " + x +  " " + y + " to " + nb)
            }
        }
    }
}

function openAdjacentMines(xFirst, yFirst, currentMineField) {

    var queue = [{
                     x: xFirst,
                     y: yFirst
                 }];
    var item, t, x, y;

    function treatOne(x, y){
        if(x>=0 && y>=0 && x < currentMineField.columns && y < currentMineField.preferredRows){
            if (currentMineField.children[x+y*currentMineField.columns].state !== "opened"
                    && currentMineField.children[x+y*currentMineField.columns].adjacentMinesCount === 0) {
                queue.push({
                               x: x,
                               y: y
                           });
            }else{
                currentMineField.children[x+y*currentMineField.columns].openEmpty();
            }
        }
    }

    while (queue.length) {

        item = queue.shift();
        x = item.x;
        y = item.y;

        currentMineField.children[x+y*currentMineField.columns].openEmpty();

        treatOne(x-1, y-1);
        treatOne(x-1, y);
        treatOne(x-1, y+1);

        treatOne(x, y-1);
        treatOne(x, y+1);

        treatOne(x+1, y-1);
        treatOne(x+1, y);
        treatOne(x+1, y+1);

    }
}
