#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

MENU_LIST(){
  SERVICE_LIST=$($PSQL "SELECT service_id,name FROM services")
  echo "$SERVICE_LIST" | while read ID BAR NAME
    do
      echo "$ID) $NAME"
    done
  read SERVICE_ID_SELECTED
  if [[ ! $SERVICE_ID_SELECTED =~ ^[1-7]$ ]]
  then
   MENU_LIST "I could not find that service. What would you like today?"
  else
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id='$SERVICE_ID_SELECTED'")
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
   if [[ -z $CUSTOMER_NAME ]]
   then
   echo -e "\nI don't have a record for that phone number, what's your name?"
   read CUSTOMER_NAME
   echo -e "\nWhat time would you like your$SERVICE_NAME, $CUSTOMER_NAME?"
   read SERVICE_TIME
   CREATE_CUSTOMER=$($PSQL "INSERT INTO customers(phone,name) VALUES('$CUSTOMER_PHONE','$CUSTOMER_NAME')")
   CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'") 
   CREATE_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id,service_id,time) VALUES('$CUSTOMER_ID','$SERVICE_ID_SELECTED','$SERVICE_TIME')")
   echo -e "\nI have put you down for a$SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
  fi
  fi
}
MAIN_MENU(){
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi
  echo -e "\n~~~~~ MY SALON ~~~~~\n"
  echo -e "Welcome to My Salon, how can I help you?"
  MENU_LIST 
}

EXIT() {
  echo -e "\nThank you for stopping in.\n"
}
MAIN_MENU
