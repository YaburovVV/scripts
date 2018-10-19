#!/usr/bin/env bash

dev_status() {
  dev=$1
  nmcli device status | grep $dev | awk '{print $3}'
}

dev_name() {
  dev=$1
  nmcli device status | grep $dev | awk '{print $1}'
}

dev_down() {
  net=$1

  if ! [[ ${net} =~ ^(wifi|ethernet)$ ]]; then
    echo Wrong parameter value - $net
    return 1
  fi

  d_status=$(dev_status $net)
  d_name=$(dev_name $net)
  echo $net сейчас $d_status
  if [ ${d_status} ==  'подключено' ]; then
    echo Отключение $net $d_name
    nmcli device disconnect $d_name
  fi
}

dev_up() {
  net=$1

  if ! [[ ${net} =~ ^(wifi|ethernet)$ ]]; then
    echo Wrong parameter value - $net
    return 1
  fi

  d_status=$(dev_status $net)
  d_name=$(dev_name $net)

  echo $d_status $d_name

  if [ ${d_status} == 'недоступен' ]; then
    echo $net $d_status
    nmcli radio wifi on
    nmcli radio wifi
  fi

  if [ ${d_status} == 'отключено' ]; then
    echo Подключение $net $d_name
    nmcli device connect $d_name
  fi
}

get_active_wifi() {
  nmcli device wifi | grep '*' | awk '{print $2}'
}

connect_wifi() {
  net=$1

  if [ $net == $(get_active_wifi) ]; then
    echo Connection $net already active
  else
    echo Connecting to $net ...
    nmcli c up $net
  fi
}

connect_miv() {
  dev_down ethernet
  dev_up wifi
  connect_wifi miv
}
connect_sbrf() {
  dev_down ethernet
  dev_up wifi
  connect_wifi SBRF
}
connect_wire() {
  dev_down wifi
  dev_up ethernet
}

command=$1

if [ "_$1" = "_" ] || ! [[ ${command} =~ ^(connect_wire|connect_sbrf|connect_miv)$ ]]; then
    echo "Please specify function name in first parameter like this (connect_wire, connect_sbrf, connect_miv)"
else
    "$@"
fi