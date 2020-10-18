#!/bin/bash

IP=$(ifconfig ens5 | grep "inet " | awk -F'[: ]+' '{ print $3 }')
TS=$(date +%s)

for((i = 0; i < $1; i++))
do
	docker cp demo$i:log$i logs/demo$i
	cat logs/demo$i >> logs/collector.$TS.$IP
	rm logs/demo*
done
