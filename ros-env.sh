#!/bin/bash
# don't forget to SOURCE!
# USAGE: source ros-nev(.sh) MASTER_IP iface
# Specify IP for the ROS master and prioritize one of the inet interfaces.
# Usually, 1 is eth* and 2 is wifi*. If not found it falls back
# to the lower one. (2>1>0) where 0 is localhost


# Get MASTER_URI's IP
M_IP=$1
# Get This machine's IP
IP="$(hostname -I)"
if [ -z $IP ] ;
then
    echo "No connection. Falling back to localhost."
    M_IP="localhost"
    IP="127.0.0.1"
elif [ "$M_IP" == "localhost" ] || [ "$M_IP" == "127.0.0.1" ] || [ -z "$M_IP" ] ;
then
    M_IP="localhost"
    IP="127.0.0.1"
else
    #check local specification
    if [ "$#" -eq 2 ] ; then
        #echo "selected $2"
        #awk doesn't support any dynamic interpretation yet ($($SEL)):(
        if [ "$2" -eq 2 ] ; then
            #echo "iface 2"
            IP="$(echo "$IP" | awk '{print $2}')"
        elif [ "$2" -eq 1 ] ; then
            #echo "iface 1"
            IP="$(echo "$IP" | awk '{print $1}')"
        elif [ "$2" -eq 3 ] ; then
            IP="$(echo "$IP" | awk '{print $3}')"
        fi
        if [  -z "$IP" ] ; then
            IP="$(echo $(hostname) | awk '{print $1}')"
        fi
    else
       IP="$(echo "$IP" | awk '{print $1}')"
    fi

    if [ "$M_IP" == "self" ] ; then
        M_IP="$IP"
    fi
fi

#setup ROS environment variables
export ROS_MASTER_URI="http://${M_IP}:11311"
export ROS_IP="${IP}"
export ROS_HOSTNAME="${ROS_IP}"

#print
echo -e "\e[93mROS_MASTER_URI: \e[38;5;82m$ROS_MASTER_URI \e[0m"
echo -e "\e[93mROS_IP: \e[38;5;82m$ROS_IP \e[0m"
echo -e "\e[93mROS_HOSTNAME: \e[38;5;82m$ROS_HOSTNAME \e[0m"
