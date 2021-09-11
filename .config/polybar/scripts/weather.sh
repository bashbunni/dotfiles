#!/bin/env bash

# Original source - https://github.com/polybar/polybar-scripts/tree/master/polybar-scripts/openweathermap-detailed

get_icon() {
  case $1 in
    01d) ICON="";;
    01n) ICON="";;
    02*) ICON="";;
    03*) ICON="";;
    04*) ICON="";;
    09*) ICON="";;
    10*) ICON="";;
    11*) ICON="";;
    13*) ICON="";;
    50*) ICON="";;
    *) ICON="";
  esac

  echo $ICON
}

# Global settings
KEY=""
CITY=""
UNITS="metric"
SYMBOL="°C"
API="https://api.openweathermap.org/data/2.5"

# Get weather
WEATHER=$(curl -sf "$API/weather?APPID=$KEY&q=$CITY&units=$UNITS")

# Check if got weather
if [ -n "$WEATHER" ]; then
  # Get condition, temp and icon
  WEATHER_MAIN=$(echo $WEATHER | jq -r ".weather[0].main")
  WEATHER_ICON=$(echo $WEATHER | jq -r ".weather[0].icon")
  WEATHER_TEMP=$(echo $WEATHER | jq -r ".main.temp")

  # Print weather
  echo "$(get_icon $WEATHER_ICON)  $WEATHER_MAIN $WEATHER_TEMP$SYMBOL"
fi
