#!bin/bash

PATH_TO_SAVE=$1
TAB=$2
IS_GAME_OVER=false
IS_GAME_FINISH=false

echo ""
echo "${TAB[*]}"
echo ""

display_tab () {
    echo "
	${TAB[0]} | ${TAB[1]} | ${TAB[2]}
	---------
	${TAB[3]} | ${TAB[4]} | ${TAB[5]}
	---------
	${TAB[6]} | ${TAB[7]} | ${TAB[8]}
	"
}

get_counter () {
    counter=0
    for i in ${TAB[*]};
    do
        if [[ $i == "X" || $i == "O" ]];
        then
            (( counter++ ))
        fi
    done
    echo $counter
}

save_game_and_exit () {
    . "${PATH_TO_SAVE}" "$TAB" "./saved_pvp_game.txt"
    IS_GAME_FINISH=true
    sleep 1s
}


check_game_is_over () {

    if [[ ${TAB[0]} == ${TAB[1]} && ${TAB[1]} == ${TAB[2]} && ${TAB[0]} !=  " " ]];
    then
		IS_GAME_OVER=true
        IS_GAME_FINISH=true
	elif [[ ${TAB[3]} == ${TAB[4]} && ${TAB[4]} == ${TAB[5]} && ${TAB[3]} !=  " " ]];
    then
		IS_GAME_OVER=true
        IS_GAME_FINISH=true
	elif [[ ${TAB[6]} == ${TAB[7]} && ${TAB[7]} == ${TAB[8]} && ${TAB[6]} !=  " " ]];
    then 
		IS_GAME_OVER=true
        IS_GAME_FINISH=true
	elif [[ ${TAB[0]} == ${TAB[3]} && ${TAB[3]} == ${TAB[6]} && ${TAB[0]} !=  " " ]];
    then
		IS_GAME_OVER=true
        IS_GAME_FINISH=true
	elif [[ ${TAB[1]} == ${TAB[4]} && ${TAB[4]} == ${TAB[7]} && ${TAB[1]} !=  " " ]];
    then
		IS_GAME_OVER=true
        IS_GAME_FINISH=true
	elif [[ ${TAB[2]} == ${TAB[5]} && ${TAB[5]} == ${TAB[8]} && ${TAB[2]} !=  " " ]];
    then
		IS_GAME_OVER=true
        IS_GAME_FINISH=true
	elif [[ ${TAB[0]} == ${TAB[4]} && ${TAB[4]} == ${TAB[8]} && ${TAB[0]} !=  " " ]];
    then
		IS_GAME_OVER=true
        IS_GAME_FINISH=true
	elif [[ ${TAB[2]} == ${TAB[4]} && ${TAB[4]} == ${TAB[6]} && ${TAB[2]} !=  " " ]];
    then
		IS_GAME_OVER=true
        IS_GAME_FINISH=true
    else
        IS_GAME_OVER=false
    fi
}


get_input () {
    echo "To save and exit please type 'save', or to continue please"
    echo "enter a value beteween 1 and 9, to put '$1' in the game: "
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
            get_input "$1"
        fi
    else
        if ! [[ $coord =~ ^[1-9]$ ]];
        then
            echo "Not a correct value!"
            get_input "$1"
        elif ! [[ ${TAB[$coord-1]} == " " ]];
        then
            echo "This is already occupied."
            get_input "$1"
        else 
            TAB[$coord-1]=${1}
        fi
    fi
}

main () {
	player1="X"
	player2="O"
	player="$player1"
    player_n=1
    COUNTER=$(get_counter)
    
    [[ 
        $COUNTER == 1 || 
        $COUNTER == 3 || 
        $COUNTER == 5 || 
        $COUNTER == 7 || 
        $COUNTER == 9 
    ]] && 
    player="$player2" || 
    player="$player1"

	while ! $IS_GAME_FINISH;
    do
        echo $COUNTER
        (( COUNTER++ ))
        display_tab
        if [[ $COUNTER -ge 10 ]]; 
        then
            echo "It's a draw, no winner this time!"
            IS_GAME_FINISH=true
            break
        fi

        [[ "$player" == "$player2" ]] && player="$player1" || player="$player2"
        [[ "$player" == "$player1" ]] && player_n=1 || player_n=2; 
		
        echo "Player $player_n, it's your turn." && echo -n "" 
		get_input $player
		check_game_is_over 
	done

    if $IS_GAME_OVER;
    then
        [[ "$player" == "$player1" ]] && player_n=1 || player_n=2; 
        display_tab && echo "Congratulation to player $player_n who won the game!"
    fi
}

main