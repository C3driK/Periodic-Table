#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

MAIN_MENU () {
  # check if there is an arguement, if not
  if [[ -z $1 ]]
  then
    echo "Please provide an element as an argument."
  elif [[ $1 =~ ^[0-9]+$ ]]
  then
    # check if that atomic number exists
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$1")
    # if that atomic number is found, use it to query the database
    if [[ -z $ATOMIC_NUMBER ]]
    then
      echo "I could not find that element in the database."
    else
      RESULT=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties
      INNER JOIN elements USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number=$ATOMIC_NUMBER")
      FRESULT=$(echo "$RESULT" | sed -E 's/^([0-9]+)\|([^|]+)\|([^|]+)\|([^|]+)\|([^|]+)\|([^|]+)\|([^|]+)$/The element with atomic number \1 is \2 (\3). It'\''s a \4, with a mass of \5 amu. \2 has a melting point of \6 celsius and a boiling point of \7 celsius./')
      echo "$FRESULT"
    fi
  # check if ARG is a symbol
  elif [[ $1 =~ ^[A-Z][a-z]?$ ]]
  then 
    # check if symbol exists
    SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE symbol='$1'")
    # check if symbol not found
    if [[ -z $SYMBOL ]]
    then
      echo "I could not find that element in the database."
    else
      RESULT=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties
      INNER JOIN elements USING(atomic_number) INNER JOIN types USING(type_id) WHERE symbol='$SYMBOL'")
      FRESULT=$(echo "$RESULT" | sed -E 's/^([0-9]+)\|([^|]+)\|([^|]+)\|([^|]+)\|([^|]+)\|([^|]+)\|([^|]+)$/The element with atomic number \1 is \2 (\3). It'\''s a \4, with a mass of \5 amu. \2 has a melting point of \6 celsius and a boiling point of \7 celsius./')
      echo "$FRESULT"
    fi
  # check if ARG is a name
  else [[ $1 =~ ^[A-Z][a-z]*$ ]]
    # check if $1 exist as a name in the database
    NAME=$($PSQL "SELECT name FROM elements WHERE name='$1'")
    # check if name is not found
    if [[ -z $NAME ]]
    then 
      echo "I could not find that element in the database."
    else
      RESULT=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties
      INNER JOIN elements USING(atomic_number) INNER JOIN types USING(type_id) WHERE name='$NAME'")
      FRESULT=$(echo "$RESULT" | sed -E 's/^([0-9]+)\|([^|]+)\|([^|]+)\|([^|]+)\|([^|]+)\|([^|]+)\|([^|]+)$/The element with atomic number \1 is \2 (\3). It'\''s a \4, with a mass of \5 amu. \2 has a melting point of \6 celsius and a boiling point of \7 celsius./')
      echo "$FRESULT"
    fi
  fi
}


MAIN_MENU $1
