#!/bin/sh
#
#./start_tmux.sh 10.0.0.8
# Create TMUX MULTIPLE WINDOW
tmux kill-server # kills historic server on start

IP_ADDRESS=$1
#IP_ADDRESS = 10.0.0.8
session="work"

# set up tmux
tmux start-server

# create a new tmux session, starting vim from a saved session in the new window
tmux new-session -d -s $session -n vim #"vim -S ~/.vim/sessions/kittybusiness"

# Select pane 1, set dir to api, run vim
tmux selectp -t 1
tmux send-keys "cd ~/Documents/Scripts" C-m
tmux send-keys "./odroid_auto_login.sh ${IP_ADDRESS}" C-m
tmux send-keys "source ./ros-env.sh ${IP_ADDRESS} 1" C-m
tmux send-keys "roslaunch makeblock_ros demo_init.launch"

# Split pane 1 horizontal by 65%, start redis-server
tmux splitw -h -p 50
tmux send-keys "cd ~/Documents/Scripts" C-m
tmux send-keys "source ./ros-env.sh ${IP_ADDRESS} 1" C-m
tmux send-keys "date --set "$(sshpass -p 'odroid' ssh root@${IP_ADDRESS} date)""

# Select pane 2
tmux selectp -t 0
# Split pane 2 vertiacally by 25%
tmux splitw -v -p 33
tmux send-keys "cd ~/Documents/Scripts" C-m
tmux send-keys "./odroid_auto_login.sh ${IP_ADDRESS}" C-m
tmux send-keys "source ./ros-env.sh ${IP_ADDRESS} 1" C-m
tmux send-keys "roslaunch realsense2_camera rs_camera.launch enable_pointcloud:=false enable_depth:=true enable_infra2:=false"

# Select pane 2
tmux selectp -t 0
# Split pane 2 vertiacally by 25%
tmux splitw -v -p 50
tmux send-keys "cd ~/Documents/Scripts" C-m
tmux send-keys "./odroid_auto_login.sh ${IP_ADDRESS}" C-m
tmux send-keys "source ./ros-env.sh ${IP_ADDRESS} 1" C-m
tmux send-keys "roslaunch makeblock_ros P2PLaunch.launch"

# select pane 3, set to api root
tmux selectp -t 3
tmux splitw -v -p 80
tmux send-keys "cd ~/Documents/Scripts" C-m
tmux send-keys "source ./ros-env.sh ${IP_ADDRESS} 1" C-m
tmux send-keys "roslaunch hector_slam_launch tutorial_.launch rviz_on:=true"

tmux selectp -t 4
tmux splitw -v -p 50
tmux send-keys "cd ~/Documents/Scripts" C-m
tmux send-keys "source ./ros-env.sh ${IP_ADDRESS} 1" C-m
tmux send-keys "rqt_image_view"


# Select pane 1
tmux selectp -t 1

# create a new window called scratch
tmux new-window -t $session:1 -n scratch

# return to main vim window
tmux select-window -t $session:0

# Finished setup, attach to the tmux session!
tmux attach-session -t $session
