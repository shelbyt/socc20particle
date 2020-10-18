#!/bin/bash

#Remove
NODES=`wc -l mstr.ips | cut -f1 -d' '`
# Plus to because first on the list is the ip
REMOV=$(($NODES-$1-1))

head -n -$REMOV mstr.ips > workers
sed  '1d' workers > workers1

