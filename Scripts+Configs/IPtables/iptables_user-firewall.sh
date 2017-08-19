#!/bin/sh

             ##::[[----->  IPtables Firewall Script  <-----]]::##

    # LEDE/OpenWrt users:
        # 1. Remove shebang
        # 2. Uncomment LEDE/OpenWrt Variables
        # 3. Save as "/etc/firewall.user"


    # OpenWrt Variables #
#---------------------------------------------------

    # LAN:
#LANIP=`uci get network.lan.ipaddr`

    # VPN:
#VPN=`uci get network.vpn.ifname`

    # WAN:
#WAN=`uci get network.wan.ifname`


    # Establish Custom Zones #
#---------------------------------------------------

    # Brute Force Ban:
iptables    -w  -N  DROP-Brute

    # Drop:
iptables    -w  -N  DROP-Zone_LAN-dest
iptables    -w  -N  DROP-Zone_WAN-dest
iptables    -w  -N  DROP-Zone_WAN-src

    # Log:
iptables    -w  -N  LOG

    # Log SSH:
iptables    -w  -N  LOG-SSH

    # Log VPN:
iptables    -w  -N  LOG-VPN

    # Rate Limit:
iptables    -w  -N  Rate_Limit

    # Reject:
iptables    -w  -N  REJECT-Zone_LAN-dest
iptables    -w  -N  REJECT-Zone_WAN-dest
iptables    -w  -N  REJECT-Zone_WAN-src


    # Establish Rate Limit #
#---------------------------------------------------

    # Pings
iptables    -w  -A  INPUT       -p  ICMP    --icmp-type echo-request        -i  $WAN                                                                                            -j  Rate_Limit

    # Brute Force Ban:
iptables    -w  -A  INPUT       -p  tcp     --dport     22                  -i  $WAN    -m  state   --state NEW -m  recent  --set
iptables    -w  -A  INPUT       -p  tcp     --dport     22                  -i  $WAN    -m  state   --state NEW -m  recent          --update    --seconds   60  --hitcount  1   -j  DROP-Brute
iptables    -w  -A  INPUT       -p  tcp     --dport     22                                                                                                                      -j  Rate_Limit

iptables    -w  -A  INPUT       -p  tcp     --dport     23                  -i  $WAN    -m  state   --state NEW -m  recent  --set
iptables    -w  -A  INPUT       -p  tcp     --dport     23                  -i  $WAN    -m  state   --state NEW -m  recent          --update    --seconds   60  --hitcount  1   -j  DROP-Brute
iptables    -w  -A  INPUT       -p  tcp     --dport     23                                                                                                                      -j  Rate_Limit

iptables    -w  -A  INPUT       -p  tcp     --dport     1194                -i  $WAN    -m  state   --state NEW -m  recent  --set
iptables    -w  -A  INPUT       -p  tcp     --dport     1194                -i  $WAN    -m  state   --state NEW -m  recent          --update    --seconds   60  --hitcount  1   -j  DROP-Brute
iptables    -w  -A  INPUT       -p  tcp     --dport     1194                                                                                                                    -j  Rate_Limit

iptables    -w  -A  INPUT       -p  udp     --dport     1194                -i  $WAN    -m  state   --state NEW -m  recent  --set
iptables    -w  -A  INPUT       -p  udp     --dport     1194                -i  $WAN    -m  state   --state NEW -m  recent          --update    --seconds   60  --hitcount  1   -j  DROP-Brute
iptables    -w  -A  INPUT       -p  udp     --dport     1194                                                                                                                    -j  Rate_Limit

    # SSH & VPN:
iptables    -w  -A  INPUT       -p  tcp     --dport     4998                -i  $WAN    -m  state   --state NEW                                                                 -j  Rate_Limit
iptables    -w  -A  INPUT       -p  tcp     --dport     4999                -i  $WAN    -m  state   --state NEW                                                                 -j  Rate_Limit
iptables    -w  -A  INPUT       -p  tcp     --dport     5000                -i  $WAN    -m  state   --state NEW                                                                 -j  Rate_Limit
iptables    -w  -A  INPUT       -p  udp     --dport     5000                -i  $WAN    -m  state   --state NEW                                                                 -j  Rate_Limit


    # Apply Rate Limit #
#---------------------------------------------------

    # Pings:
iptables    -w  -A  Rate_Limit      -p  ICMP    --icmp-type echo-request    -i  $WAN    -m  limit   --limit 4/sec                               -j  ACCEPT

    # SSH & VPN:
iptables    -w  -A  Rate_Limit      -p  tcp     --dport     4998            -i  $WAN    -m  limit   --limit 3/min   --limit-burst   3           -j  LOG-SSH
iptables    -w  -A  Rate_Limit      -p  tcp     --dport     4999            -i  $WAN    -m  limit   --limit 3/min   --limit-burst   3           -j  LOG-SSH

iptables    -w  -A  Rate_Limit      -p  tcp     --dport     5000            -i  $WAN    -m  limit   --limit 3/min   --limit-burst   3           -j  LOG-VPN
iptables    -w  -A  Rate_Limit      -p  udp     --dport     5000            -i  $WAN    -m  limit   --limit 3/min   --limit-burst   3           -j  LOG-VPN

    # Drop / Reject:
iptables    -w  -A  Rate_Limit      -p  tcp                                                                                                     -j  REJECT          --reject-with   tcp-reset
iptables    -w  -A  Rate_Limit      -p  udp                                                                                                     -j  REJECT          --reject-with   icmp-port-unreachable
iptables    -w  -A  Rate_Limit  !   -p  ICMP                                                                                                    -j  LOG             --log-prefix    "<[[--- Connection DROPPED ---]]>: "
iptables    -w  -A  Rate_Limit                                                                                                                  -j  DROP


    # Log All Dropped #
#---------------------------------------------------

    # Brute Force Ban:
iptables    -w  -A  DROP-Brute              -j  LOG     --log-prefix    "<[[--- BRUTE Force DROPPED ---]]> : "  --log-level 4
iptables    -w  -A  DROP-Brute              -j  DROP

    # Inbound LAN:
iptables    -w  -A  DROP-Zone_LAN-dest      -j  LOG     --log-prefix    "<[[--- LAN Inbound DROPPED ---]]> : "  --log-level 4
iptables    -w  -A  DROP-Zone_LAN-dest      -j  DROP

    # Inbound WAN:
iptables    -w  -A  REJECT-Zone_WAN-src     -j  LOG     --log-prefix    "<[[--- WAN Inbound DROPPED ---]]> : "  --log-level 4
iptables    -w  -A  REJECT-Zone_WAN-src     -j  DROP

    # Outbound WAN:
iptables    -w  -A  REJECT-Zone_WAN-dest    -j  LOG     --log-prefix    "<[[--- WAN Outbound DROPPED ---]]> : " --log-level 4
iptables    -w  -A  REJECT-Zone_WAN-dest    -j  DROP


    # Log SSH & VPN Traffic #
#---------------------------------------------------

    # SSH:
iptables    -w  -A  LOG-SSH     -p  tcp     --dport     4998    -j  LOG-VPN
iptables    -w  -A  LOG-SSH                                     -j  LOG         --log-prefix    "<[[---  SSH Traffic ---]]> : "         --log-level 4
iptables    -w  -A  LOG-SSH                                     -j  ACCEPT

    # VPN:
iptables    -w  -A  LOG-VPN     -p  tcp     --dport     4998    -j  LOG         --log-prefix    "<[[--- VPN --> SSH Traffic ---]]> : "  --log-level 4
iptables    -w  -A  LOG-VPN                                     -j  LOG         --log-prefix    "<[[---  VPN Traffic ---]]> : "         --log-level 4
iptables    -w  -A  LOG-VPN                                     -j  ACCEPT



    # Additional Examples #
#---------------------------------------------------


        # DNScrypt:
    #-----------------------------------------------

    # DNS Pass-Through:
    # iptables        -t  nat -A  prerouting_rule !       -d  $LANIP  -p  udp --dport 53  -j  REDIRECT
    # iptables        -t  nat -A  prerouting_rule !       -d  $LANIP  -p  tcp --dport 53  -j  REDIRECT


        # AdHosts:
    #-----------------------------------------------

    # Redirects Traffic to Ourself:
    # iptables    -w  -t  nat -A  prerouting_rule -p tcp  -d  192.168.1.254   --dport 80  -j  REDIRECT    --to-ports  81

    # Reject Everything Else:
    # iptables    -w          -A  forwarding_rule -d  192.168.1.254                       -j  REJECT

