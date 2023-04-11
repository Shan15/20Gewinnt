#!/bin/bash

# 20gewinnt.bash
# -----------------------
# 13.04.2023 Fabio Kälin, Shansai Muraleetharan, Taha Ali
# -----------------------
# 20 Gewinnt ist ein Spiel, bei dem zwei Spieler abwechselnd
# entweder 1 oder 2 auswählen, um die aktuelle Zahl erhöhen.
# Der Spieler, der als die Zahl 20 erreicht, hat gewonnen.

# Required
# gameMode = "pvp" or "pve" or "eve"
# difficulty = "easy" or "medium" or "hard"
difficulty="medium"
gameMode="pve"
startTime=$(date +%s)
currentValue=0

# Colors
# User1 \033[36m
# User2 \033[35m
# Bot \033[33m
# Fail \033[31m
# Default \033[0m

askCompetitionMode(){
    echo -e "\033[0mWählen Sie den gewünschten Spielmodus aus: "
    echo -e "\033[0mpvp(1)"
    echo -e "\033[0mpve(2)"
    echo -e "\033[0meve(3)"
    read -p "" gameModeInput
    if [ "$gameModeInput" = "1" ]; then
        gameMode="pvp"
        echo -e "\033[0mDu hast PVP gewählt."
    elif [ "$gameModeInput" = "2" ]; then
        gameMode="pve"
        echo -e "\033[0mDu hast PVE gewählt."
    elif [ "$gameModeInput" = "3" ]; then
        gameMode="eve"
        echo -e "\033[0mDu hast EVE gewählt."
    else
        echo -e "\033[31mBitte nur 1, 2 oder 3 eingeben"
        askCompetitionMode
    fi
}

askDifficultyMode(){
    if [ $gameMode = "pve" ]; then
        echo -e "\033[0mWählen Sie die gewünschte Schwierigkeitsstufe aus: "
        echo -e "\033[0mleicht(1)"
        echo -e "\033[0mmittel(2)"
        echo -e "\033[0mschwer(3)"
        read -p "" difficulty
        if [ "$difficulty" = "1" ]; then
            difficulty="easy"
            echo -e "\033[0mDu hast die Schwierigkeitsstufe leicht gewählt."
        elif [ "$difficulty" = "2" ]; then
            difficulty="medium"
            echo -e "\033[0mDu hast die Schwierigkeitsstufe mittel gewählt."
        elif [ "$difficulty" = "3" ]; then
            difficulty="hard"
            echo -e "\033[0mDu hast die Schwierigkeitsstufe schwer gewählt."
        else
            echo -e "\033[31mBitte nur 1, 2 oder 3 eingeben"
            askDifficultyMode
        fi
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
    echo -e "\033[0m--------------------------"
    echo -e "\e[1;95mLeaderboard:"
    echo ""
    echo -e "\e[1;93mName | Zeit"
    echo ""
    cat winner.csv | cut -d "," -f 1,2 | sort -t "," -k 2 -n | head -n 10 | sed 's/,/ |/g'
    echo -e "\033[0m--------------------------"
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
    read -p "Aktuller Stand ist $currentValue - $currentPlayer, wie viel möchtest du hinzufügen (1 oder 2)? " playerInput
    # Validate playerinput
    while [ "$playerInput" != 1 ] && [ "$playerInput" != 2 ]; do
        echo -e "\033[31mBitte nur 1 oder 2 eingeben\033[0m"
        echo -en "${userColor}"
        read -p "Aktuller Stand ist $currentValue, $currentPlayer , wie viel möchtest du hinzufügen (1 oder 2)? " playerInput
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
        elif [ $currentValue -eq 18 ] || [ $currentValue -eq 15 ]; then
            botInput=2
        else
            botInput=$((RANDOM % 2 + 1))
        fi
    else
        botInput=$((RANDOM % 2 + 1))
    fi

    echo -e "${userColor}Aktuller Stand ist $currentValue - Der $currentPlayer \xf0\x9f\xa4\x96 wird $botInput hinzufügen\033[0m"
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


game() {
    echo -e "\033[0mWillkommen zu 20 Gewinnt."
    askCompetitionMode
    askDifficultyMode
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
            sleep 0.5

            userColor="\033[35m"
            currentPlayer="Bot 2"
            getBotInput
            checkEnd
            sleep 0.5
        fi
    done
}

game