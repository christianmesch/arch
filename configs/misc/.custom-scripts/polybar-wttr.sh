#!/usr/bin/env bash

current=`curl -s wttr.in/Kista?format=1`
emoji=`echo $current | cut -d ' ' -f1`
temp=`echo $current | cut -d ' ' -f2-`

function toIcon() {
  case $1 in
    ✨) icon="";; # Starry
    ☀️) icon="";; # Sunny
    ⛅️) icon="";; # Day Cloudy
    ☁️) icon="";; # Cloudy
    🌫) icon="";; # Very cloudy
    🌧) icon="";; # Rain
    ❄️) icon="";; # Snowflake cold
    🌦) icon="";; # Day rain
    🌨) icon="";; # Snow
    🌩) icon="";; # Lightning
    ⛈) icon="";; # Thunder storm
    *) icon="";; # Default (thermometer)
  esac

  echo $icon
}

echo "%{F#555555}$(toIcon "$emoji") %{F-}$temp"