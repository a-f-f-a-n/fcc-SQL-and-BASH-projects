#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ The Amazing Salon Scheduler ~~~~~\n"

MAIN_MENU() {
    if [[ $1 ]]
    then
      echo -e "\n$1"
    fi

    echo "What service would you like? Enter the number"
    echo -e "\n1) cut\n2) color\n3) perm\n4) style\n5) trim\n6) massage\n7) tanning\n8) waxing\n9) exit"
    read SERVICE_ID_SELECTED     #new variable made here

    case $SERVICE_ID_SELECTED in
      1) SERVICE "cut" ;;
      2) SERVICE "color";;
      3) SERVICE "perm";;
      4) SERVICE "style";;
      5) SERVICE "trim";;
      6) SERVICE "massage";;
      7) SERVICE "tanning";;
      8) SERVICE "waxing";;
      9) EXIT ;;
      *) MAIN_MENU "We don't have that service." ;;
     esac
}
SERVICE() {
  SERVICE_ID=$($PSQL "SELECT service_id FROM services WHERE name = '$1'")
  
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")

  # if customer doesn't exist
  if [[ -z $CUSTOMER_NAME ]]
  then
    # get new customer name
    echo -e "\nYou must be new here, what is your name?"
    read CUSTOMER_NAME

    INSERT_CUSTOMER=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
  fi
  echo -e "\nWhat time would you like your $1, $(echo $CUSTOMER_NAME | sed -r 's/^ *| *$//g')?"

  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  # CUSTOMER_FORMATTED=
  SERVICE_ID=$($PSQL "SELECT service_id FROM services WHERE name = '$1'")
  read SERVICE_TIME       #assuming that the customer is entering a valid time
  
  INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID, '$SERVICE_TIME')")
  echo -e "\nI have put you down for a $1 at $SERVICE_TIME, $(echo $CUSTOMER_NAME | sed -r 's/^ *| *$//g')."
}
EXIT() {
  echo -e "\nThanks for coming by!\n"
}

MAIN_MENU 


