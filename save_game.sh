#!bin/bash

TAB=$1
SAVE=$2

touch "${SAVE}"
printf "%s\n" "${TAB[@]}" > "${SAVE}"
