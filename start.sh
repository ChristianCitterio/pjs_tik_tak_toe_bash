#!bin/bash
TAB=()
RESUME=false
PVP=false
CHECK_LOOP=false

continue_to_play () {
    echo "Do you want to continue to play?(y/n) "
    read -r response
    if [[ $response == "N" || $response == "n" ]];
    then
        echo "See you next time!"
        exit 0
    else
        echo "What we do next?"
    fi
}

pvp_game() {
    echo "Hi! plese select mode: "
    options=("pvp" "pve" "exit game")
    select opt in "${options[@]}"
    do
        case $opt in
            "pvp")
                echo "Running pvp game..."
                PVP=true
                break
                ;;
            "pve")
                echo "Running pve game..."
                PVP=false
                break
                ;;
            "exit game")
                exit 0
                ;;
            *) 
                echo "Invalid choice!"
                pvp_game
                break
        esac
    done
}

resume_game () {
    
    [[ $PVP == false ]] && SAVE="./saved_pve_game.txt" || SAVE="./saved_pvp_game.txt" 
    
    if [[ -f "${SAVE}" ]];
    then
        echo "You have a saved game, do you want to resume it?(y/n)"
        read -r response
        if [[ $response == "y" || $response == "Y" ]];
        then
            echo "loading game..."
            RESUME=true
        elif [[ $response ==  "n" || $response == "N" ]];
        then
            echo "Starting a new game..."
            RESUME=false
        else
            echo "Not valid value"
        fi
    else
        echo "No saved game present"
        echo "Starting a new game..."
        RESUME=false
    fi
}

main () {
    while ! $CHECK_LOOP;
    do
        pvp_game
        if ! $PVP; 
        then 
            GAME="./pve.sh"
        else    
            GAME="./pvp.sh"
        fi
        resume_game
        sleep 1s
        if ! $RESUME;
        then 
            TAB=(" " " " " " " " " " " " " " " " " ")
            source "${GAME}" "./save_game.sh" "${TAB}"
        else
            IFS=$'\r\n' GLOBIGNORE='*' command eval  'TAB=($(cat "./saved_game.txt"))'
            rm -r "./saved_game.txt"
            source "${GAME}" "./save_game.sh" "${TAB}"
        fi
        continue_to_play
    done
}

main && exit 0