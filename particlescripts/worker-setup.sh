#!/usr/bin/env bash


IP=$(ifconfig ens5 | grep "inet " | awk -F'[: ]+' '{ print $3 }')
LINE5="bgp router-id $IP"
LINE14="neighbor $IP  peer-group reflectors"
LINE2="MASTERIP='$IP'"

echo "Finished set ip address"
sed -i "5s/.*/ $LINE5 /" /home/ubuntu/transfer/quagga/Quagga.conf

#echo "Finished set ip address"
#sed -i "2s/.*/ $LINE2 /" /home/ubuntu/ip-start-many.sh
docker kill quagga
docker rm quagga
docker run -t -d --privileged --name quagga -p 179:179 --hostname docker -v /home/ubuntu/transfer/quagga:/etc/quagga shelbyt/quagga:CL3.2.1_evpn

echo "Finished start docker"
sudo /home/ubuntu/setup_vxlan 42 container:quagga  nolearning
echo "Finished setup vxlan"

echo "Loading image for shuffle"
docker load -i /home/ubuntu/shuffle.tar
