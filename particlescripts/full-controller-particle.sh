#!/usr/bin/env bash

#Number of nodes
bash set-node.sh $1

bash -x controller-setup.sh 
parallel-scp -r -h workers -x "-i MYPEM.pem" transfer/ /home/ubuntu/
parallel-scp -r -h workers -x "-i MYPEM.pem" worker-setup.sh /home/ubuntu/
pdsh -w ^workers sudo bash -x worker-setup.sh
### Only need to do this on first run
parallel-scp -r -h workers -x "-i MYPEM.pem" setup_master.sh /home/ubuntu/
parallel-scp -r -h workers -x "-i MYPEM.pem" clean_up.sh /home/ubuntu/
parallel-scp -r -h workers -x "-i MYPEM.pem" gen-iproute2.sh /home/ubuntu/
parallel-scp -r -h workers -x "-i MYPEM.pem" exec_collect.sh /home/ubuntu/
parallel-scp -r -h workers -x "-i MYPEM.pem" parallel-start-many-particle.sh /home/ubuntu/
parallel-scp -r -h workers -x "-i MYPEM.pem" ip-start-many-particle.sh /home/ubuntu/
parallel-scp -r -h workers -x "-i MYPEM.pem" manual-ssh-particle.sh /home/ubuntu/
parallel-scp -r -h workers -x "-i MYPEM.pem" create-pool.sh /home/ubuntu/

#pdsh -w ^workers1 sudo mkdir logs/tmp
DEMOS=100
THREADS=$2
# How many demo$i's per machine
bash -x manual-ssh-particle.sh $DEMOS
sleep 3
TS_START=p$(date +%s)
#pdsh -w ^workers1 sudo bash  -x ip-start-many-particle.sh 0 $DEMOS
pdsh -w ^workers1 sudo bash  -x parallel-start-many-particle.sh 0 $DEMOS $THREADS 192.168.250.250
sleep 10
pdsh -w ^workers1 sudo bash  exec_collect.sh $DEMOS


mkdir results/$TS_START
rpdcp -w ^workers1 logs/collector* results/$TS_START/
#pdsh -w ^workers1 sudo mv logs/demo* logs/tmp/ #the script that collects should do this but current doesnt
pdsh -w ^workers1 sudo mv logs/collect* logs/tmp/
pdsh -w ^workers1 sudo bash clean_up.sh $DEMOS


cat results/$TS_START/* >> results/$TS_START/full
echo "start=$TS_START" >> results/$TS_START/full
sort -g results/$TS_START/full >  results/$TS_START/full.sort


exit



