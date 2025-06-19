#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=salon -t --no-align -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"
echo "Welcome to My Salon, how can I help you?"

MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi
 
  echo -e "\n1) cut\n2) perm\n3) color"
  read SERVICE_ID_SELECTED

  case $SERVICE_ID_SELECTED in
    1) cut ;;
    2) perm ;;
    3) color ;;
    4) EXIT ;;
    *) MAIN_MENU "I could not find that service. What would you like today?" ;;
  esac
}

cut() {
  SERVICE_CONTENT=$($PSQL "SELECT name FROM services WHERE service_id = '$SERVICE_ID_SELECTED'")
}
perm() {
  SERVICE_CONTENT=$($PSQL "SELECT name FROM services WHERE service_id = '$SERVICE_ID_SELECTED'")
}
color() {
  SERVICE_CONTENT=$($PSQL "SELECT name FROM services WHERE service_id = '$SERVICE_ID_SELECTED'")
}

APPOINTMENT_BOOKING() {
#if $SERVICE_ID_SELECTED is 1-3, then ask for phone, set $CUSTOMER_PHONE
  if [[ $SERVICE_ID_SELECTED -lt 4 ]] 
  then
    echo -e "\nWhat's your phone number?"
    read CUSTOMER_PHONE
#check input $CUSTOMER_PHONE in customers table, if found set value: $CUSTOMER_NAME
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
#if name not found, ask for name, set $CUSTOMER_NAME
    if [[ -z $CUSTOMER_NAME ]] 
    then
      echo -e "\nI don't have a record for that phone number, what's your name?"
      read CUSTOMER_NAME
#insert $CUSTOMER_PHONE, $name into customers table
      ADD_NEW_CUSTOMER=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
    fi
  fi
      customer_id=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
#ask for time (use $SERVICE_ID_SELECTED $CUSTOMER_NAME), set $SERVICE_TIME ($SERVICE_ID_SELECTED, $CUSTOMER_PHONE, $CUSTOMER_NAME, $SERVICE_TIME)
      echo -e "\nWhat time would you like your $SERVICE_CONTENT, $CUSTOMER_NAME?"
      read SERVICE_TIME
#insert $SERVICE_TIME, customer_id via $CUSTOMER_PHONE, service_id via $SERVICE_ID_SELECTED
      ADD_NEW_APPOINTMENT=$($PSQL "INSERT INTO appointments(time, service_id, customer_id) VALUES('$SERVICE_TIME', '$SERVICE_ID_SELECTED', '$customer_id')")
#reply with $SERVICE_TIME, $SERVICE_CONTENT, $CUSTOMER_NAME
      echo -e "\nI have put you down for a $SERVICE_CONTENT at $SERVICE_TIME, $CUSTOMER_NAME."
}

MAIN_MENU
APPOINTMENT_BOOKING
