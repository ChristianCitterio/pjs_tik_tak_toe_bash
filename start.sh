TAB=(" " " " " " " " " " " " " " " " " ")

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
            return 1
        elif [[ $response ==  "n" || $response == "N" ]];
        then
            return 0
        else
            echo "Not valid value"
            return $(resume_game)
        fi
    else
        echo "No saved game present"
        return 0
    fi
}

while true;
do
    resume=$(resume_game)
    if ! [[ resume == 1 ]];
    then 
        . "./tick_tack_toe.sh" "./save_game.sh" "${TAB}"
    else
        IFS=$'\r\n' GLOBIGNORE='*' command eval  '${TAB}=($(cat "./saved_game.txt"))'
        echo $TAB
        . "./tick_tack_toe.sh" "./save_game.sh" "${TAB}"
    fi
    continue_to_play
done
