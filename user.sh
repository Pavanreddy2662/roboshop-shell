# shellcheck disable=SC2034
script_path=$(dirname $0)
# shellcheck disable=SC2086
source ${script-path}/ common.sh

exit

echo -e "\e[36m>>>>>>>>> configuring NodeJS repos <<<<<<<<<<\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

echo -e "\e[36m>>>>>>>>> install NodeJS <<<<<<<<<<\e[0m"
yum install nodejs -y

echo -e "\e[36m>>>>>>>>> Add Application User <<<<<<<<<<\e[0m"
# shellcheck disable=SC2154
useradd ${app_user}

echo -e "\e[36m>>>>>>>>> Create Application Directory <<<<<<<<<<\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[36m>>>>>>>>> Download App Content <<<<<<<<<<\e[0m"
curl -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip
cd /app

echo -e "\e[36m>>>>>>>>> Unzip App Content <<<<<<<<<<\e[0m"
unzip /tmp/user.zip

echo -e "\e[36m>>>>>>>>> Install NodeJS Dependencies <<<<<<<<<<\e[0m"
npm install


echo -e "\e[36m>>>>>>>>> Copy user SystemD <<<<<<<<<<\e[0m"
cp /home/centos/roboshop-shell/user.service /etc/systemd/system/user.service

echo -e "\e[36m>>>>>>>>> Start user Service <<<<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable user
systemctl restart user

echo -e "\e[36m>>>>>>>>> Copy MongoDB Repo <<<<<<<<<<\e[0m"
cp /home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[36m>>>>>>>>> Install MongoDB Client <<<<<<<<<<\e[0m"
yum install mongodb-org-shell -y

echo -e "\e[36m>>>>>>>>> Load schema <<<<<<<<<<\e[0m"
mongo --host mongodb-dev.pdevopsb72.online </app/schema/user.js
