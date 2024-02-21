#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=salon -c"
MAIN_MENU(){
  echo -e "Welcome to My Salon, how can I help you?"
  SERVICE_OPTION=$($PSQL "SELECT * FROM services")
  echo "$SERVICE_OPTION" | while read  SERVICE_ID BAR SERVICE_NAME
  do
    if [[ $SERVICE_ID > 0 ]]
    then 
      echo "$SERVICE_ID) $SERVICE_NAME"
    fi 
  done
  read SERVICE
}
echo -e "\n~~~~~ MY SALON ~~~~~\n"
MAIN_MENU