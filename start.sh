#!bin/bash
TAB=
RESUME=false
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

resume_game () {
    if [[ -f "./saved_game.txt" ]];
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
        resume_game
        sleep 1s
        if ! $RESUME;
        then 
            TAB=(" " " " " " " " " " " " " " " " " ")
            source "./tick_tack_toe.sh" "./save_game.sh" "${TAB}"
        else
            IFS=$'\r\n' GLOBIGNORE='*' command eval  'TAB=($(cat "./saved_game.txt"))'
            rm -r "./saved_game.txt"
            source "./tick_tack_toe.sh" "./save_game.sh" "${TAB}"
        fi
        continue_to_play
    done
}

main && exit 0