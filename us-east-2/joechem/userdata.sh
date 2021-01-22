#!/bin/bash

apt-get update
apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

add-apt-repository ppa:certbot/certbot

add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io python-certbot-nginx

curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

chmod +x /usr/local/bin/docker-compose

# fs setup
while [ ! -b /dev/nvme1n1 ]
do 
    echo "waiting for device /dev/nvme1n1"; sleep 2
done

mkdir -p /storage01/docker/
#blkid /dev/nvme1n1 || ( mkfs -t xfs -L storage01 /dev/nvme1n1 && echo 'LABEL=storage01 /storage01 xfs  defaults,nofail  0  2'  >> /etc/fstab )
blk_id=$(blkid /dev/nvme1n1 | cut -d ' ' -f2)
echo "${blk_id} /storage01 xfs defaults,nofail  0  2" >> /etc/fstab
#mount -a

# sync step
aws s3 cp s3://joechem-deployment-files/docker-compose.yml /storage01/docker/docker-compose.yml
aws s3 cp s3://joechem-deployment-files/database.env /storage01/docker/database.env

cd /storage/docker
docker-compose up -d
