#!/bin/bash
sudo apt update -y
sudo curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
source ~/.bashrc
nvm --version
nvm list-remote
nvm install v16
node -v
npm install -g node-red
npm install -g pm2
pm2 start node-red
pm2 restart node-red
pm2 save
pm2 status
mkdir -p /home/instance1
mkdir -p /home/instance2
cp -r /root/.node-red/* /home/instance1
cp -r /root/.node-red/* /home/instance2
echo "module.exports = {
  apps: [
    {
      name: 'node-red-instance0',
      script: 'node-red',
      args: ['-p', '1880', '-s', '/root/.node-red/settings.js', '-u', '/root/.node-red/'],
    },
    {
      name: 'node-red-instance1',
      script: 'node-red',
      args: ['-p', '1881', '-s', '/home/instance1/settings.js', '-u', '/home/instance1/'],
    },
    {
      name: 'node-red-instance2',
      script: 'node-red',
      args: ['-p', '1882', '-s', '/home/instance2/settings.js', '-u', '/home/instance2/'],
    }
  ],
};" > /home/ecosystem.config.js
pm2 reload ecosystem.config.js
pm2 restart ecosystem.config.js
pm2 status
pm2 list
sudo sed -i 's/1880/1881/g' /home/instance1/setting.js
sudo sed -i 's/1880/1882/g' /root/instance2/setting.js
echo "ui: {
          path: "ui"
        },
       adminAuth: {
          type: "credentials",

           users: [{
                  username: "admin1",
                  password: "$2b$08$G1mjiDEiEAh00dcjc.UCg.monNcxxplHHMK9015cvMMWCKFZ86P4y",  //password 

                  permissions: "*"

         }]
                  }," >> /home/instance1/setting.js
echo "ui: {
          path: "ui"
        },
       adminAuth: {
          type: "credentials",

           users: [{
                  username: "admin1",
                  password: "$2b$08$G1mjiDEiEAh00dcjc.UCg.monNcxxplHHMK9015cvMMWCKFZ86P4y",  //password 

                  permissions: "*"

         }]
                  }," >> /home/instance2/setting.js
node-red restart
pm2 reload /home/ecosystem.config.js
pm2 restart /home/cosystem.config.js
pm2 save
ufw allow 1881/tcp
ufw allow 1882/tcp
pm2 restart /home/ecosystem.config.js
