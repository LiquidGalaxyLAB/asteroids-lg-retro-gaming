#!/bin/bash

PW="$1"

BASE_FOLDER="/home/lg/lg-retro-gaming"

#Create file name with name as date
date=$(date +%Y-%m-%d)
filename="$date.txt"

# Add to log with timestamp
time=$(date +%H:%M:%S)
echo "[$time] Installing Liquid Galaxy Retro Gaming..."

# Open port 3123

LINE=`cat /etc/iptables.conf | grep "tcp" | grep "8111" | awk -F " -j" '{print $1}'`

RESULT=$LINE",3123"

DATA=`cat /etc/iptables.conf | grep "tcp" | grep "8111" | grep "3123"`

if [ "$DATA" == "" ]; then
    time=$(date +%H:%M:%S)
    echo "[$time] Port 3123 not open, opening port..."
    echo $PW | sudo -S sed -i "s/$LINE/$RESULT/g" /etc/iptables.conf
else
    time=$(date +%H:%M:%S)
    echo "[$time] Port already open."
fi

# Install dependencies on server folder
time=$(date +%H:%M:%S)
echo "[$time] Installing dependencies..."
cd $BASE_FOLDER/server
echo $PW | sudo -S npm install -y
cd ..

# Add access for pm2
echo $PW | sudo -S chown lg:lg /home/lg/.pm2/rpc.sock /home/lg/.pm2/pub.sock

# Stop server if already started
echo $PW | sudo -S pm2 delete LGRG_PORT:3123 2> /dev/null

# Start server
time=$(date +%H:%M:%S)
echo "[$time] Starting pm2..."
echo $PW | sudo -S pm2 start ./server/index.js --name LGRG_PORT:3123

echo $PW | sudo -S pm2 save

# Add automatic pm2 resurrect script
time=$(date +%H:%M:%S)
echo "[$time] Updating resurrect script..."
RESURRECT=$(pm2 startup | grep 'sudo')
echo $PW | sudo -S eval $RESURRECT

time=$(date +%H:%M:%S)
echo "[$time] Installation complete. Reboot machine to finish installation"
