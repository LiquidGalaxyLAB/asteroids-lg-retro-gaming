# Liquid Galaxy Retro Gaming

The idea of playing games on the Liquid Galaxy has already been explored by some developers, there are currently two classic retro games that have been implemented: pong and snake, but there is no easy way to install and run these games on a Liquid Galaxy. By creating a basic app with icons representing each game any person with a tablet could easily control which game is being displayed on the screens and even quickly switch between them.

## Before Running
- Make sure Node.js version 14 is installed on the master machine, if necessary use the following link for tips on how to install it:
[How To Install Node.js on Ubuntu 16.04](https://tecadmin.net/install-latest-nodejs-npm-on-ubuntu/)
- After Node.js is installed, Install pm2 on master machine. Run command:
```bash
sudo npm i -g pm2
```

## Installing The Project
After cloning the repository in the master machine navigate to the cloned folder and execute the installation script:
```bash
cd lg-retro-gaming

sudo bash install.sh
```

Once the installation is finished, make sure to reboot the machine.

If you experience any problems, check the installation logs for any possible errors in the logs folder, there will be a file with the date of installation as it's name.

## App setup
Now that the server is running, make sure the android device and the liquid galaxy are connected to the **same wi-fi** network berfore running the app. Once that's done, the setup is very simple.
- First, open the app and go to the settings page (cog icon on the top right of the screen)
- On the settings screens set all the variables to the following values
    - Server Ip: Master machine ipv4 (including the dots e.g.: 192.168.0.123)
    - Server Port: 3123
    - Pacman Port: 8128
    - Snake Port: 8114
    - Pong Port: 8112
- Once all the values are set, click the “Save” button on the bottom of the screen.
- The app is now ready to be used!
