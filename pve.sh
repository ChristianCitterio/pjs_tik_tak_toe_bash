#!bin/bash
IS_GAME_FINISH=false
PATH_TO_SAVE=$1
tab=$2

display() {
    echo "
    ${tab[0]} | ${tab[1]} | ${tab[2]}
    ---------
    ${tab[3]} | ${tab[4]} | ${tab[5]}
    ---------
    ${tab[6]} | ${tab[7]} | ${tab[8]}
    "
}

count_free_space() {
    free_spaces=0
    for i in "${tab[@]}"; do
        if [ "$i" == " " ]; then
            (( count_free_space++ ))        
        fi
    done
    echo $free_spaces
}

minmax(){
    # Choosing a random start position
    if [ $(count_free_space) -eq 9 ]; then
        best_move=$(( RANDOM % 8 ))
    else
        max
    fi  
}

min () {
    local empty_space=()
    indexCase=0
    for i in "${tab[@]}"; do
        if [ "$i" == " " ]; then
            empty_space+=($indexCase)
        fi
        (( indexCase++ ))
    done
    
    local bestTemp=-1
    local scoreTemp=$PLUS_INFINITY
    
    for i in "${empty_space[@]}"; do
        tab[$i]="O"
        local stockItemp=$i
        max
        i=$stockItemp
        tab[$i]=" "
        if [[ $scoreTemp -gt $scoreMinMax ]]; then
            local scoreTemp=$scoreMinMax
            local bestTemp=$i
            if [[ $scoreTemp -eq $MINUS_INFINITY ]]; then
                break
            fi
        fi
    done
    scoreMinMax=$scoreTemp
    best_move=$bestTemp
}

max (){
    local empty_space=()
    indexCase=0
    for i in "${tab[@]}"; do
        if [ "$i" == " " ]; then
            empty_space+=($indexCase)
        fi
        (( indexCase++ ))
    done
    
    local bestTemp=-1
    local scoreTemp=$MINUS_INFINITY
    
    for i in "${empty_space[@]}"; do
        tab[$i]="X"
        local stockItemp=$i
        min
        i=$stockItemp
        tab[$i]=" "
        if [[ $scoreTemp -lt $scoreMinMax ]]; then
            local scoreTemp=$scoreMinMax
            local bestTemp=$i
            if [[ $scoreTemp -eq $PLUS_INFINITY ]]; then
                break
            fi
        fi
    done
    scoreMinMax=$scoreTemp
    best_move=$bestTemp
}


is_game_finish () {

    # Line
    if   [[ ${tab[0]} == ${tab[1]} ]] && [[ ${tab[1]} == ${tab[2]} ]] && [[ ${tab[0]} !=  " " ]];
    then
        IS_GAME_FINISH=true
        IS_GAME_OVER=true
    elif [[ ${tab[3]} == ${tab[4]} ]] && [[ ${tab[4]} == ${tab[5]} ]] && [[ ${tab[3]} !=  " " ]];
    then
        IS_GAME_FINISH=true
        IS_GAME_OVER=true
    elif [[ ${tab[6]} == ${tab[7]} ]] && [[ ${tab[7]} == ${tab[8]} ]] && [[ ${tab[6]} !=  " " ]];
    then
        IS_GAME_FINISH=true
        IS_GAME_OVER=true
    elif [[ ${tab[0]} == ${tab[3]} ]] && [[ ${tab[3]} == ${tab[6]} ]] && [[ ${tab[0]} !=  " " ]];
    then
        IS_GAME_FINISH=true
        IS_GAME_OVER=true
    elif [[ ${tab[1]} == ${tab[4]} ]] && [[ ${tab[4]} == ${tab[7]} ]] && [[ ${tab[1]} !=  " " ]];
    then
        IS_GAME_FINISH=true
        IS_GAME_OVER=true
    elif [[ ${tab[2]} == ${tab[5]} ]] && [[ ${tab[5]} == ${tab[8]} ]] && [[ ${tab[2]} !=  " " ]];
    then
        IS_GAME_FINISH=true
        IS_GAME_OVER=true
    elif [[ ${tab[0]} == ${tab[4]} ]] && [[ ${tab[4]} == ${tab[8]} ]] && [[ ${tab[0]} !=  " " ]];
    then
        IS_GAME_FINISH=true
        IS_GAME_OVER=true
    elif [[ ${tab[2]} == ${tab[4]} ]] && [[ ${tab[4]} == ${tab[6]} ]] && [[ ${tab[2]} !=  " " ]];
    then
        IS_GAME_FINISH=true
        IS_GAME_OVER=true
    else
        IS_GAME_FINISH=false
        IS_GAME_OVER=false
    fi
}

save_game_and_exit () {
    . "${PATH_TO_SAVE}" "$TAB" "./saved_pve_game.txt"
    IS_GAME_FINISH=true
    sleep 1s
}

ask (){
    echo "Enter a value between 1 and 9 which is in a free space :"
    read -r coord
    if [[ $coord == "save" ]];
    then
        echo "Are you sure you want to save and exit the game?(y/n) "
        read -r response
        if [[ $response == "y" || $response == "Y" ]];
        then
            echo "Saving the current game and exit"
            save_game_and_exit
        else
            ask
        fi
    else
        if ! [[ "$coord" =~ ^[1-9]$ ]];
        then
            echo -n "Not a correct value! "
            ask
        elif [ "${tab[${coord-1}]}" == " " ];
        then
            tab[$coord-1]="O"
        else
            echo "This position is already taken! "
            ask
        fi
    fi
}

main () {
    
    player=1
    display

    while ! $IS_GAME_FINISH;
    do
        if [ "$player" -eq 1 ];
        then
            ask
        else
            echo -n "Compute IA turn ..."
            minmax
            echo " Done.";
            tab[$best_move]="X"
        fi
        display
        [ $player -eq 1 ] && player=2 || player=1
    done

    if [[ $IS_GAME_OVER && $player -eq 2 ]];
    then
        echo "AI wins the game!"
    elif [[ $IS_GAME_OVER && $player -eq 1 ]];
    then
        echo "Congratulation you won the game!"
    elif [[$IS_GAME_FINISH && $(count_free_space) -eq 0 ]];
    then
        echo "It's a draw, no winner !"
    fi

}

main