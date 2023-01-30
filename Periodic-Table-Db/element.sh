PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"
if [[ -z $1 ]] # if there are no arguments
then
  echo Please provide an element as an argument.
else
  if [[ $1 =~ ^[0-9]+$ ]]   # if the first argument is a number
  then 
    ELEMENT=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = $1")
  else # if the first argument is a string
    ELEMENT=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$1' OR name = '$1'")  
  fi
  if [[ -z $ELEMENT ]] # if the element is not found
  then
    echo "I could not find that element in the database."
  else # if element is found, join all three tables and find the atomic number by the ELEMENT variable/query
    INFO=$($PSQL "SELECT * FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE atomic_number = $ELEMENT")
    echo "$INFO" | while read TYPE_ID BAR ATOMIC_NUMBER BAR SYMBOL BAR NAME BAR ATOMIC_MASS BAR MELTING_POINT BAR BOILING_POINT BAR TYPE # use read/while loop to get all the properties of the element 
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done
  fi
fi
