#! /bin/bash
PSQL="psql --username=freecodecamp --dbname=salon -t -c"

main_menu () {

echo -e "\nPlease select a service:"
SERVICE_LIST=$($PSQL "SELECT * FROM services")
echo -e "\n$SERVICE_LIST" | sed 's/ |/)/'
read SERVICE_ID_SELECTED;
SERVICE=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")

if [[ $SERVICE_ID_SELECTED =~ ^[1-3]$ ]]
then
  echo -e "\n Enter your phone number.\n"
  read CUSTOMER_PHONE
## if this is a new customer add their info and appointment to the database
  if [[ -z $($PSQL "SELECT phone FROM customers WHERE phone='$CUSTOMER_PHONE'") ]]
  then
    echo -e "\nWe don't have your phone in our database. Please enter your name.\n"
    read CUSTOMER_NAME
    CUSTOMER_INSERT=$($PSQL "INSERT INTO customers(phone,name) VALUES('$CUSTOMER_PHONE','$CUSTOMER_NAME')")
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    echo -e "\nEnter the desired time for your service.\n"
    read SERVICE_TIME
    APPOINTMENT_INSERT=$($PSQL "INSERT INTO appointments(customer_id,service_id,time) VALUES($CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME')")
    echo -e "\nI have put you down for a $SERVICE at $SERVICE_TIME, $CUSTOMER_NAME.\n"
## if the customer is a returning one, ask for service time and add the appointment to the database
  else
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  echo -e "\nHello $CUSTOMER_NAME. Enter the desired time for your service.\n"
  read SERVICE_TIME
  APPOINTMENT_INSERT=$($PSQL "INSERT INTO appointments(customer_id,service_id,time) VALUES($CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME')")
  echo -e "\nI have put you down for a $SERVICE at $SERVICE_TIME, $CUSTOMER_NAME.\n"
  fi
## if the selection is anything other than numbers of the services
else
echo -e "\n!!! Invalid selection. !!!"
main_menu
fi


}

main_menu