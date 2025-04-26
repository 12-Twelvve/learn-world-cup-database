#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
cat games.csv | tail -n +2 | awk -F',' '{print $3"\n"$4}' | sort | uniq | while read team
do
  $PSQL "INSERT INTO teams(name) VALUES ('$team') ON CONFLICT (name) DO NOTHING;"
done

# Skip the header
tail -n +2 games.csv | while IFS=',' read -r y r w o wg og
do
  # Get team IDs
  winner_id=$($PSQL "SELECT team_id FROM teams WHERE name='$w';")
  opponent_id=$($PSQL "SELECT team_id FROM teams WHERE name='$o';")

  # Insert the game row
  $PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($y, '$r', $winner_id, $opponent_id, $wg, $og);"
done