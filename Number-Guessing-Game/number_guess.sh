#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"
#$PSQL "TRUNCATE users, games"
NUM=$(( RANDOM % 1000 + 1 )) #does not include 1000 or 0, goes up to 1000
echo -e "\nEnter your username:"
read USERNAME
USER=$($PSQL "SELECT username FROM users WHERE username = '$USERNAME'")
if [[ -z $USER ]]
then
  echo -e "\nWelcome, $USERNAME! It looks like this is your first time here."
  INSERT=$($PSQL "INSERT INTO users(username) VALUES('$USERNAME')")
else
  GAMES_PLAYED=$($PSQL "SELECT COUNT(guesses) FROM games FULL JOIN users USING(user_id) WHERE username = '$USERNAME'")
  BEST_GAME=$($PSQL "SELECT MIN(guesses) FROM games FULL JOIN users USING(user_id) WHERE username = '$USERNAME'")
  echo -e "\nWelcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi
TRIES=1
echo -e "\nGuess the secret number between 1 and 1000:"
INPUT=0
RIGHT_ANSWER=false
while [[ $INPUT -ne $NUM ]]
do
  read INPUT
  if [[ ! $INPUT =~ ^[0-9]+$ ]]
  then 
    echo -e "\nThat is not an integer, guess again:"
    let TRIES++ #let allows you to do arithmetic/increments
    continue
  fi
  if [[ $INPUT -lt $NUM ]]
  then
    echo -e "\nIt's higher than that, guess again:"
    let TRIES++ 
  elif [[ $INPUT -gt $NUM ]]
  then 
    echo -e "\nIt's lower than that, guess again:"
    let TRIES++
  fi
  if [[ $INPUT -eq $NUM ]]
  then
    RIGHT_ANSWER=true
  fi
done
if [[ "$RIGHT_ANSWER" = true ]] #not keeping this if statement will make invalid inputs like {}[]-= exit the program
then 
  GET_USER_ID=$($PSQL "SELECT user_id FROM users WHERE username = '$USERNAME'")
  INSERT_GUESSES=$($PSQL "INSERT INTO games(user_id, guesses) VALUES('$GET_USER_ID', $TRIES)")
  echo -e "\nYou guessed it in $TRIES tries. The secret number was $NUM. Nice job!"
fi
  