#!/bin/bash

#Usage 
## ./parallel-start-many.sh 0 100 5 # Will start VM#0 to VM#99 5 at a time.

start="${1}"
count="${2}"
parallel="${3}"
master_ip=${4}

if [[ -z $start || -z $count || -z $parallel || -z $master_ip ]]; then echo need 3 arguments; exit 1; fi

echo Start @ `date`.
START_TS=`date +%s%N | cut -b1-13`
for ((i=0; i<parallel; i++)); do
  s=$((i * count / parallel + start))
  e=$(((i+1) * count / parallel + start))
  ./ip-start-many-particle.sh $s $e $master_ip &
  pids[${i}]=$!
done

# wait for all pids
for pid in ${pids[*]}; do
    wait $pid
done

END_TS=`date +%s%N | cut -b1-13`
END_DATE=`date`

total=$((count))
delta_ms=$((END_TS-START_TS))
delta=$((delta_ms/1000))
rate=`bc -l <<< "$total/$delta"`

cat << EOL
Done @ $END_DATE.
Started $total containers in $delta_ms milliseconds.
Mutation rate was $rate per second.
EOL


