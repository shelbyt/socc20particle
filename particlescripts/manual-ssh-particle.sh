#!/bin/bash

readarray -t NODELIST < "/home/ubuntu/workers"

NODES=${#NODELIST[@]}
WORKERS=$(($NODES - 1))

for((i=0; i < ${#NODELIST[@]}; i++))
do

	if [ $i -eq 0 ]
	then

	ssh  ${NODELIST[$i]} -i ~/shelbyoreo.pem -o StrictHostKeyChecking=no sudo bash -x  setup_master.sh
	sleep 1
		continue
	fi 	

	#ssh  ${NODELIST[$i]} -i ~/shelbyoreo.pem -o StrictHostKeyChecking=no sudo bash  gen-iproute2.sh -i $1 -n $i
	ssh  ${NODELIST[$i]} -i ~/shelbyoreo.pem -o StrictHostKeyChecking=no sudo bash  create-pool.sh -i $1 -n $i


done
