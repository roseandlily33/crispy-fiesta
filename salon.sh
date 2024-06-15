#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

SELECT_SERVICE() {
  SERVICES=$($PSQL "SELECT * FROM services ORDER BY service_id")
  echo "$SERVICES" | while read SERVICE_ID BAR NAME
  do
   echo "$SERVICE_ID) $NAME"
  done
  # Get the input from which user they would like
  read SERVICE_ID_SELECTED
  if [[ $SERVICE_ID_SELECTED != [1-3] ]]  
  then
  #If the service is not valid it returns the user back to the main menu
    SELECT_SERVICE
  else 
  #Make an appointment
    MAKE_APPOINTMENT
  fi
}

MAKE_APPOINTMENT() {
  # Get the customers phone number
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE
  NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
  CUSTOMER_NAME=$(echo $NAME | sed 's/ //g')
  if [[ -z $NAME ]]
  then
  #If theres no customer name found make the account
    echo -e "\nNo account found, What's your name?"
    read CUSTOMER_NAME
    NAME=$(echo $NAME | sed 's/ //g')
    SAVED_TO_CUSTOMERS=$($PSQL "INSERT INTO customers(name,phone) VALUES('$NAME','$CUSTOMER_PHONE')")
  fi
  #Get the services name
  GET_SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
  # Fomat the service name
  SERVICE_NAME=$(echo $GET_SERVICE_NAME| sed 's/ //g')
  # Get the customers id
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  #Ask for the service time
  echo -e "\nWhat time would you like your $SERVICE_NAME, $CUSTOMER_NAME?"
  read SERVICE_TIME
  # Save to the appointments table
  SAVED_TO_APPOINTMENTS=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
  if [[ $SAVED_TO_TABLE_APPOINTMENTS == "INSERT 0 1" ]]
  then
  #Message for the user
    echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
  fi

}

SELECT_SERVICE

