#!bin/bash

TAB=$1

touch "./saved_game.txt"
printf "%s\n" "${TAB[@]}" > "./saved_game.txt"
exit 0