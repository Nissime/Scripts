
#using sshpass
#sudo apt-get install sshpass
#sshpass -p 'password' ssh user@server
#sshpass -p 'password' ssh -o StrictHostKeyChecking=no  user@server
IP=$1
sshpass -p 'odroid' ssh root@${IP}
