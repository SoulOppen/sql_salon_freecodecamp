#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=salon -t -c "
MAIN_MENU(){
  echo -e "Welcome to My Salon, how can I help you?"
  SERVICE_OPTION=$($PSQL "SELECT * FROM services")
  echo "$SERVICE_OPTION" | sed -E 's/-*\+-*//'| grep -v '^$' | while read  SERVICE_ID BAR SERVICE_NAME
  do
    if [[ $SERVICE_ID != 'service_id' ]]
    then 
      echo "$SERVICE_ID) $SERVICE_NAME"
    fi 
  done
  read SERVICE_ID_SELECTED
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
  if [[ -z $SERVICE_NAME ]]
  then 
      MAIN_MENU
  else 
      echo -e "What's your phone number?"
      read CUSTOMER_PHONE
      CUSTOMER_NAME="$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")"
      if [[ -z $CUSTOMER_NAME ]]
      then
        echo -e "\nI don't have a record for that phone number, what's your name?"
        read CUSTOMER_NAME
        INSERT_CUSTOMER=$($PSQL "INSERT INTO customers(phone,name) VALUES('$CUSTOMER_PHONE','$CUSTOMER_NAME')")
      fi
      echo -e "\nWhat time would you like to $SERVICE_NAME, $CUSTOMER_NAME?"
      read SERVICE_TIME
      CUSTOMER_ID="$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")"
      INSERT_SERVICE="$($PSQL "INSERT INTO appointments(time,customer_id,service_id) VALUES('$SERVICE_TIME','$CUSTOMER_ID','$SERVICE_ID_SELECTED')")"
      if [[ $INSERT_SERVICE ==  "INSERT 0 1" ]]
      then
        echo -e "\nI have put you down for a cut at $SERVICE_TIME, $CUSTOMER_NAME."
      fi
  fi
}
echo -e "\n~~~~~ MY SALON ~~~~~\n"
MAIN_MENU