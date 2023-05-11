#!/bin/bash
sudo chmod -R 775 /home/ec2-user/webapp
# printf "\n" >> /home/ec2-user/webapp/.env
# printf "DB_ENDPOINT = '%s'\n" "$1" >> /home/ec2-user/webapp/.env
# printf "DB_NAME = '%s'\n" "$2" >> /home/ec2-user/webapp/.env
# printf "DB_USERNAME = '%s'\n" "$3" >> /home/ec2-user/webapp/.env
# printf "DB_PASSWORD = '%s'\n" "$4" >> /home/ec2-user/webapp/.env
# printf "BUCKET_NAME = '%s'\n" "$5" >> /home/ec2-user/webapp/.env
# printf "REGION = '%s'\n" "$6" >> /home/ec2-user/webapp/.env
# printf "PORT = '3030'\n" >> /home/ec2-user/webapp/.env
# printf "filename = 'file'\n" >> /home/ec2-user/webapp/.env

{ printf "DB_ENDPOINT = '%s'\n" "${DB_ENDPOINT}"
  printf "DB_NAME = '%s'\n" "${DB_NAME}"
  printf "DB_USERNAME = '%s'\n" "${DB_USERNAME}"
  printf "DB_PASSWORD = '%s'\n" "${DB_PASSWORD}"
  printf "BUCKET_NAME = '%s'\n" "${BUCKET_NAME}"
  printf "REGION = '%s'\n" "${REGION}"
  printf "PORT = '3030'\n"
  printf "filename = 'file'\n"
} >> /home/ec2-user/webapp/.env

sleep 15
sudo chmod 777 /home/ec2-user/webapp
sudo chmod 777 /home/ec2-user/webapp/uploads
# sudo systemctl enable webapp.service
# sudo systemctl start webapp.service
# sleep 5
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/opt/cloudwatch-config.json -s
sudo chmod 777 /home/ec2-user/webapp/logs
sleep 15
sudo systemctl enable webapp.service
sudo systemctl start webapp.service
sudo yum install polkit
sudo systemctl restart amazon-cloudwatch-agent.service
sleep 20
sudo systemctl restart webapp.service
sleep 15
