#!/bin/sh
#
# Setup a work space called `work` with two windows
# first window has 3 panes.
# The first pane set at 65%, split horizontally, set to api root and running vim
# pane 2 is split at 25% and running redis-server
# pane 3 is set to api root and bash prompt.
# note: `api` aliased to `cd ~/path/to/work`
#
tmux kill-server # kills historic server

session="work"

# set up tmux
tmux start-server

# create a new tmux session, starting vim from a saved session in the new window
tmux new-session -d -s $session -n vim #"vim -S ~/.vim/sessions/kittybusiness"

# Select pane 1, set dir to api, run vim
tmux selectp -t 1
tmux send-keys "cd ~/Documents/Scripts" C-m
tmux send-keys "./odroid_auto_login.sh" C-m
tmux send-keys "source ./ros-env.sh 10.0.0.8 1" C-m
tmux send-keys "roslaunch makeblock_ros demo_init.launch"

# Split pane 1 horizontal by 65%, start redis-server
tmux splitw -h -p 50
tmux send-keys "cd ~/Documents/Scripts" C-m
tmux send-keys "source ./ros-env.sh 10.0.0.8 1" C-m
tmux send-keys "date --set "$(sshpass -p 'odroid' ssh root@10.0.0.8 date)"" C-m

# Select pane 2
tmux selectp -t 0
# Split pane 2 vertiacally by 25%
tmux splitw -v -p 33
tmux send-keys "cd ~/Documents/Scripts" C-m
tmux send-keys "./odroid_auto_login.sh" C-m
tmux send-keys "source ./ros-env.sh 10.0.0.8 1" C-m
tmux send-keys "roslaunch realsense2_camera rs_camera.launch enable_pointcloud:=false enable_depth:=true enable_infra2:=false"

# Select pane 2
tmux selectp -t 0
# Split pane 2 vertiacally by 25%
tmux splitw -v -p 50
tmux send-keys "cd ~/Documents/Scripts" C-m
tmux send-keys "./odroid_auto_login.sh" C-m
tmux send-keys "source ./ros-env.sh 10.0.0.8 1" C-m
tmux send-keys "roslaunch makeblock_ros P2PLaunch.launch"

# select pane 3, set to api root
tmux selectp -t 3
tmux splitw -v -p 80
tmux send-keys "cd ~/Documents/Scripts" C-m
tmux send-keys "source ./ros-env.sh 10.0.0.8 1" C-m
tmux send-keys "roslaunch hector_slam_launch tutorial_.launch rviz_on:=true"

tmux selectp -t 4
tmux splitw -v -p 50
tmux send-keys "cd ~/Documents/Scripts" C-m
tmux send-keys "source ./ros-env.sh 10.0.0.8 1" C-m
tmux send-keys "rqt_image_view"


# Select pane 1
tmux selectp -t 1

# create a new window called scratch
tmux new-window -t $session:1 -n scratch

# return to main vim window
tmux select-window -t $session:0

# Finished setup, attach to the tmux session!
tmux attach-session -t $session
