#!/usr/bin/env bash

if [ "$LOGNAME" = travis ];then
  sudo apt-get install figlet toilet
else
  gem install travis
  sudo apt-get install xsel
fi


