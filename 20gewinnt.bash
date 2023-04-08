#!/bin/bash

# 20 Gewinnt

# 20 Gewinnt ist ein Spiel, bei dem zwei Spieler abwechselnd
# entweder 1 oder 2 auswählen, um die aktuelle Zahl erhöhen.
# Der Spieler, der als die Zahl 20 erreicht, hat gewonnen.

currentValue=0

# Required
# gameMode = "pvp" or "pve" or "eve"
# difficulty = "easy" or "medium" or "hard"
difficulty="medium"
gameMode="pve"
startTime=$(date +%s)

# Colors
# User1 \033[36m
# User2 \033[35m
# Bot \033[33m
# Fail \033[31m
# Default \033[0m

askCompetitionMode(){
    echo -e "\033[0mWillkommen zu 20 Gewinnt. Bitte wähle eines der folgenden Modi aus: "
    echo -e "\033[0mpvp(1)"
    echo -e "\033[0mpve(2)"
    echo -e "\033[0meve(3)"
    read -p "" gameMode
    if [ $gameMode = "1" ]; then
        gameMode="pvp"
        echo -e "\033[0mDu hast PVP gewählt."
    elif [ $gameMode = "2" ]; then
        gameMode="pve"
        echo -e "\033[0mDu hast PVE gewählt."
    elif [ $gameMode = "3" ]; then
        gameMode="eve"
        echo -e "\033[0mDu hast EVE gewählt."
    else
        echo -e "\033[0mBitte nur pvp, pve oder eve eingeben eingeben"
        askCompetitionMode
    fi
}

printWinner(){
    if [ $gameMode = "eve" ]; then
        echo -e "\033[32m${currentPlayer} hat gewonnen\033[0m"
    elif [ $currentPlayerType = "player" ]; then
        echo -e "\033[32mGlückwunsch $currentPlayer, du hast gewonnen!\033[0m"
        endTime=$(date +%s)
        echo $currentPlayer, $(($endTime - $startTime)) Sekunden, $currentValue >> winner.csv
        printLeaderboard
    else
        echo -e "\033[31mDer Bot hat gewonnen!\033[0m"
    fi
}

printLeaderboard(){
    echo -e "\033[0mLeaderboard: "
    echo -e "\033[0mName, Zeit"
    cat winner.csv | cut -d "," -f 1,2 | sort -t "," -k 2 -n | head -n 10
}

checkEnd(){
    if [ $currentValue -ge 20 ]; then
        printWinner
        exit 0
    fi
}

getUserInput(){
    currentPlayerType="player"
    echo -en "${userColor}"
    read -p "Aktuller Stand is $currentValue - $currentPlayer, wie viel möchtest du hinzufügen (1 oder 2)? " playerInput
    echo -en "\033[0m"
    # Validate playerinput
    while [ $playerInput -ne 1 ] && [ $playerInput -ne 2 ]; do
        echo -e "\033[31mBitte nur 1 oder 2 eingeben\033[0m"
        echo -en "${userColor}"
        read -p "Aktuller Stand is $currentValue, $currentPlayer, wie viel möchtest du hinzufügen (1 oder 2)? " playerInput
        echo -en "\033[0m"
    done

    currentValue=$((currentValue + playerInput))
}

getBotInput(){
    currentPlayerType="bot"

    if [ $difficulty = "easy" ]; then
        botInput=$((RANDOM % 2 + 1))
    elif [ $difficulty = "medium" ]; then
        if [ $currentValue -eq 18 ]; then
            botInput=2
        else
            botInput=$((RANDOM % 2 + 1))
        fi
    elif [ $difficulty = "hard" ]; then
        if [ $currentValue -eq 16 ] || [ $currentValue -eq 17 ]; then
            botInput=1
        elif [ $currentValue -eq 18 ]; then
            botInput=2
        elif [ $currentValue -eq 15 ]; then
            botInput=2
        else
            botInput=$((RANDOM % 2 + 1))
        fi
    else
        botInput=$((RANDOM % 2 + 1))
    fi

    echo -e "${userColor}Aktuller Stand is $currentValue - Der Bot wird $botInput hinzufügen\033[0m"
    currentValue=$((currentValue + botInput))
}

getUserName(){
if [ $gameMode = "pve" ]; then
    echo -en "\033[36m"
    read -p "wie heisst du? " player1Name
    echo -en "\033[0m"
    startTime=$(date +%s)
elif [ $gameMode = "pvp" ]; then
    echo -en "\033[36m"
    read -p "wie heisst der erste Spieler? " player1Name
    echo -en "\033[0m"
    echo -en "\033[35m"
    read -p "wie heisst der zweite Spieler? " player2Name
    echo -en "\033[0m"
    startTime=$(date +%s)
fi
}

askCompetitionMode
getUserName


while true; do
    if [ $gameMode = "pvp" ]; then
        userColor="\033[36m"
        currentPlayer="$player1Name"
        getUserInput
        checkEnd

        userColor="\033[35m"
        currentPlayer="$player2Name"
        getUserInput
        checkEnd
    fi

    if [ $gameMode = "pve" ]; then
        userColor="\033[36m"
        currentPlayer="$player1Name"
        getUserInput
        checkEnd

        userColor="\033[33m"
        currentPlayer="Bot"
        getBotInput
        checkEnd
    fi

    if [ $gameMode = "eve" ]; then
        userColor="\033[36m"
        currentPlayer="Bot 1"
        getBotInput
        checkEnd

        userColor="\033[35m"
        currentPlayer="Bot 2"
        getBotInput
        checkEnd
        sleep 1
    fi
done

