#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  echo -e "\n. - - Listado de servicios del Salon - - ."
	
  LISTADO=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id")
  echo "$LISTADO" | while read SERVICE_ID BAR NAME
  do
    echo "$SERVICE_ID) $NAME"	
  done
	
  echo -e "\nSeleccionar una opcion:" 
  read SERVICE_ID_SELECTED
  VERIFICACION_SERVICE_ID_SELECTED=$($PSQL "SELECT service_id FROM services WHERE service_id = $SERVICE_ID_SELECTED")
  if [[ -z $VERIFICACION_SERVICE_ID_SELECTED ]]
  then
    MAIN_MENU "Opcion incorrecta."
  else
    echo Favor de ingresar numero de telefono:
    read CUSTOMER_PHONE
    VERIFICACION_PHONE=$($PSQL "SELECT customer_id FROM customers WHERE '$CUSTOMER_PHONE' = phone")
    if [[ -z $VERIFICACION_PHONE ]]
    then
      echo Favor de ingresar su nombre:
      read CUSTOMER_NAME
      INGRESO_CUSTOMER_NUEVO=$($PSQL "INSERT INTO customers (phone, name) VALUES ('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
    fi
    echo Ingresar hora del turno:
    read SERVICE_TIME
  fi
  
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE' ")
  INGRESO_APPOINTMENT=$($PSQL "INSERT INTO appointments (service_id, customer_id, time) VALUES ($SERVICE_ID_SELECTED, $CUSTOMER_ID, '$SERVICE_TIME') ") 
  NOMBRE_SERVICIO=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
  echo "I have put you down for a $NOMBRE_SERVICIO at $SERVICE_TIME, $CUSTOMER_NAME."

}

MAIN_MENU
