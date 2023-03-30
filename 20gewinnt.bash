#!/bin/bash

# 20 Gewinnt

# 20 Gewinnt ist ein Spiel, bei dem zwei Spieler abwechselnd
# entweder 1 oder 2 die aktuelle Zahl erhöhen.
# Der Spieler, der als die Zahl 20 erreicht, hat gewonnen.

currentValue=0
# read -p "Multiplayer(m) oder Singleplayer(s)? " gameMode

# if [ $gameMode = "m" ]; then
#     echo "multiplayer"
# fi

# if [ $gameMode = "s" ]; then
#     echo "singelplayer"
# fi

printWinner(){
    echo "Glückwunsch $currentPlayer, du hast gewonnen!"
    exit 0
}

read -p "wie heißt du? " playerName

while true; do
    currentPlayer="$playerName"
    read -p "Aktuller Stand is $currentValue - $playerName, wie viel möchtest du hinzufügen (1 oder 2)? " playerInput
    # Validate playerinput
    while [ $playerInput -ne 1 ] && [ $playerInput -ne 2 ]; do
        echo "Bitte nur 1 oder 2 eingeben"
        read -p "Aktuller Stand is $currentValue, $playerName, wie viel möchtest du hinzufügen (1 oder 2)? " playerInput
    done

    currentValue=$((currentValue + playerInput))

    # Check if currentValue is bigger or equal to 20
    if [ $currentValue -ge 20 ]; then
        printWinner
    fi

    # Bots turn
    currentPlayer="Bot"
    botInput=$((RANDOM % 2 + 1))
    echo "Aktuller Stand is $currentValue - Der Bot wird $botInput hinzufügen"
    currentValue=$((currentValue + botInput))

    if [ $currentValue -ge 20 ]; then
        printWinner
    fi

done

