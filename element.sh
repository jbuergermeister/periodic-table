#! /bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit 0
else
  CHECK_SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE symbol='$1';")
  CHECK_NAME=$($PSQL "SELECT name FROM elements WHERE name='$1';")
  CHECK_ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$1;")

  if [[ ! -z $CHECK_ATOMIC_NUMBER ]]
  then
    RETRIEVE_INFO=$($PSQL "SELECT elements.atomic_number,name,symbol,type,atomic_mass,melting_point_celsius,boiling_point_celsius FROM elements JOIN properties ON elements.atomic_number=properties.atomic_number JOIN types ON properties.type_id=types.type_id WHERE elements.atomic_number=$1;")
    echo $RETRIEVE_INFO | while read ATOMIC_NUMBER BAR NAME BAR SYMBOL BAR TYPE BAR MASS BAR MELTING BAR BOILING
    do
      echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
    done
  elif [[ ! -z $CHECK_SYMBOL ]]
  then
    RETRIEVE_INFO=$($PSQL "SELECT elements.atomic_number,name,symbol,type,atomic_mass,melting_point_celsius,boiling_point_celsius FROM elements JOIN properties ON elements.atomic_number=properties.atomic_number JOIN types ON properties.type_id=types.type_id WHERE symbol='$1';")
    echo $RETRIEVE_INFO | while read ATOMIC_NUMBER BAR NAME BAR SYMBOL BAR TYPE BAR MASS BAR MELTING BAR BOILING
    do
      echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
    done
  elif [[ $CHECK_NAME ]]
  then
    RETRIEVE_INFO=$($PSQL "SELECT elements.atomic_number,name,symbol,type,atomic_mass,melting_point_celsius,boiling_point_celsius FROM elements JOIN properties ON elements.atomic_number=properties.atomic_number JOIN types ON properties.type_id=types.type_id WHERE name='$1';")
    echo $RETRIEVE_INFO | while read ATOMIC_NUMBER BAR NAME BAR SYMBOL BAR TYPE BAR MASS BAR MELTING BAR BOILING
    do
      echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
    done
  else
    echo "I could not find that element in the database."
    exit 0
  fi
fi