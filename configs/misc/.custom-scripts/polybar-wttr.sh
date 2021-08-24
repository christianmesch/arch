#!/usr/bin/env bash

current=$(curl -s wttr.in/Sundsvall?format=1)
emoji=$(echo $current | cut -d ' ' -f1)
temp=$(echo $current | cut -d ' ' -f2-)

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

# wttr.in runs out of requests from time to time and will return a long text explaining this.
# If the response is too long, print N/A instead.
if [ ${#temp} -ge 10 ]; then
  temp="N/A"
fi

echo "%{F#555555}$(toIcon "$emoji") %{F-}$temp"
