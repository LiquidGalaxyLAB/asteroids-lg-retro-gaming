#!/bin/bash

#Create logs directory if it doesnt exist yet
mkdir -p ./logs

PW="$1"

#Create file name with name as date
date=$(date +%m-%d-%y)
filename="$date.txt"

# Add to log with timestamp
time=$(date +%H:%M:%S)
echo "[$time] Installing Liquid Galaxy Retro Gaming..." | tee -a ./logs/$filename

# Open port 3123

LINE=`cat /etc/iptables.conf | grep "tcp" | grep "8111" | awk -F " -j" '{print $1}'`

RESULT=$LINE",3123"

DATA=`cat /etc/iptables.conf | grep "tcp" | grep "8111" | grep "3123"`

if [ "$DATA" == "" ]; then
    time=$(date +%H:%M:%S)
    echo "[$time] Port 3123 not open, opening port..." | tee -a ./logs/$filename
    echo $PW | sudo -S sed -i "s/$LINE/$RESULT/g" /etc/iptables.conf 2>> ./logs/$filename
else
    time=$(date +%H:%M:%S)
    echo "[$time] Port already open." | tee -a ./logs/$filename
fi

# Install dependencies on server folder
time=$(date +%H:%M:%S)
echo "[$time] Installing dependencies..." | tee -a ./logs/$filename
cd server
npm install 2>> ../logs/$filename
cd ..

# Add access for pm2
echo $PW | sudo -S chown lg:lg /home/lg/.pm2/rpc.sock /home/lg/.pm2/pub.sock

# Stop server if already started
echo $PW | sudo -S pm2 delete LGRG_PORT:3123 2> /dev/null

# Start server
time=$(date +%H:%M:%S)
echo "[$time] Starting pm2..." | tee -a ./logs/$filename
echo $PW | sudo -S pm2 start ./server/index.js --name LGRG_PORT:3123 2>> ./logs/$filename

echo $PW | sudo -S pm2 save 2>> ./logs/$filename

# Add automatic pm2 resurrect script
time=$(date +%H:%M:%S)
echo "[$time] Updating resurrect script..." | tee -a ./logs/$filename
RESURRECT=$(pm2 startup | grep 'sudo')
eval $RESURRECT 2>> ./logs/$filename

time=$(date +%H:%M:%S)
echo "[$time] Installation complete. Reboot machine to finish installation" | tee -a ./logs/$filename
