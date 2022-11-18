#!/usr/bin/env bash

DAY=$(date +%a)

if [[ ($DAY = "Sat") || ($DAY = "Sun") ]]; then
 if [[ ($(id -nG $PAM_USER) = "admins") ]]
  then
   exit 0
  else
   exit 1
 fi
fi
