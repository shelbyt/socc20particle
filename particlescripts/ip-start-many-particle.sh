#!/bin/bash
MASTERIP='192.168.250.250' 

#Usage 
## sudo ./start.sh 0 100 # Will start VM#0 to VM#99. 

readarray -t IPLIST < "/home/ubuntu/ip-pool" 
#docker run -it -v /root/particle/utils/nc/logs:/logs/ --name=test1 alpine /bin/sh

start="${1:-0}"
upperlim="${2:-1}"

for ((i=start; i<upperlim; i++)); do
	# Start container demo and keep it running
	docker run --net=container:particle --name demo$i -itd alpine /bin/sh 

	# Setup IPs
	#dnetns_path=$(docker inspect --format="{{ .NetworkSettings.SandboxKey}}" demo$i)
	#ln -sf "$dnetns_path" "/var/run/netns/demo$i"
        #ip --batch demogen/demo$i

	# Start NC	
	docker exec -d demo$i /bin/sh -c "nc -s ${IPLIST[$i]} 192.168.250.250 5000 <<EOF>log$i; tail -f /dev/null"
	#docker exec -d demo$i /bin/sh -c "nc  $MASTERIP  5000 <<EOF > log$i; tail -f /dev/null"
	#until ( nc 192.168.250.250  5000 <<EOF ;) ; do echo 'retrying...';  sleep 1;  done > logST; tail -f /dev/null

done

# Start IP COmmand


#for ((i=start; i<upperlim; i++)); do
#	docker exec --name demo$i -d alpine /bin/sh -c 'nc master 5000 <<EOF; tail -f /dev/null'
#done


