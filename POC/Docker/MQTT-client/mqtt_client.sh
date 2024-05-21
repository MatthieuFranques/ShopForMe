#!/bin/bash
while true
do
  mosquitto_pub -h mqtt_broker -p 1883 -t test -m "hello world MQTT"
  sleep 30
done
