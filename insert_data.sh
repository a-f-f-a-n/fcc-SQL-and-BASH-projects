#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

#echo $($PSQL "TRUNCATE games, teams") #uncomment this if using this on a test database
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $WINNER != "winner" ]] #&& $ROUND = "Eighth-Final" ]] # to make the insertion faster, but it'll be in a different order
  then 
    WINNER_TEAM=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    OPPONENT_TEAM=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    # if winner or opponent not found in db then:
    if [[ -z $WINNER_TEAM ]]
    then 
      RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      if [[ $RESULT == "INSERT 0 1" ]]
      then
        echo Inserted into teams database, $WINNER
      fi
    fi
    if [[ -z $OPPONENT_TEAM ]]
    then 
      RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      if [[ $RESULT == "INSERT 0 1" ]]
      then
        echo Inserted into teams database, $OPPONENT
      fi
    fi
  fi
done
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != "year" ]]
  then
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES('$YEAR', '$ROUND', '$WINNER_ID', '$OPPONENT_ID', '$WINNER_GOALS', '$OPPONENT_GOALS')")
    if [[ $RESULT = "INSERT 0 1" ]]
    then
     echo Inserted into games, $YEAR, $ROUND, $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS
    fi
  fi
done
