#!/bin/sh

    ##::[[---  OpenWrt UCI Config Check Script  ---]]::##

#===========================================================
                  ##--- Error Check ---##
#===========================================================

# Check for errors in /etc/config:
#-----------------------------------------------------------
(
  for CONF in /etc/config/*; do
    uci show "${CONF##*/}" > /dev/null || echo "${CONF}"
  done
) 2>&1 | logger -t "-- !!! CONFIG FILE ERROR !!! --" & exit
