#!/bin/bash

# 20 Gewinnt

# 20 Gewinnt ist ein Spiel, bei dem zwei Spieler abwechselnd
# entweder 1 oder 2 die aktuelle Zahl erhöhen.
# Der Spieler, der als die Zahl 20 erreicht, hat gewonnen.

currentValue=0

# Required
# gameMode = "pvp" or "pve" or "eve"

# read -p "Multiplayer(m) oder Singleplayer(s)? " gameMode

# if [ $gameMode = "m" ]; then
#     echo "multiplayer"
# fi

# if [ $gameMode = "s" ]; then
#     echo "singelplayer"
# fi

printWinner(){
    # check if player or bot won
    if [ $currentPlayerType = "player" ]; then
        echo -e "\033[32mGlückwunsch $currentPlayer, du hast gewonnen!\033[0m"
    else
        echo -e "\033[31mDer Bot hat gewonnen!\033[0m"
    fi
    exit 0
}

checkEnd(){
    if [ $currentValue -ge 20 ]; then
        printWinner
    fi
}

getUserInput(){
    currentPlayerType="player"
    read -p "Aktuller Stand is $currentValue - $playerName, wie viel möchtest du hinzufügen (1 oder 2)? " playerInput
    # Validate playerinput
    while [ $playerInput -ne 1 ] && [ $playerInput -ne 2 ]; do
        echo "Bitte nur 1 oder 2 eingeben"
        read -p "Aktuller Stand is $currentValue, $playerName, wie viel möchtest du hinzufügen (1 oder 2)? " playerInput
    done

    currentValue=$((currentValue + playerInput))
}

getBotInput(){
    currentPlayerType="bot"
    botInput=$((RANDOM % 2 + 1))
    echo "Aktuller Stand is $currentValue - Der Bot wird $botInput hinzufügen"
    currentValue=$((currentValue + botInput))
}

read -p "wie heißt du? " playerName

while true; do
    currentPlayer="$playerName"
    getUserInput
    checkEnd

    currentPlayer="Bot"
    getBotInput
    checkEnd
done

