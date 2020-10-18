#!/usr/bin/env bash

# A POSIX variable
OPTIND=1         # Reset in case getopts has been used previously in the shell.

usage() { echo "Usage: $0 [-i <how many to start>]" 1>&2; exit 1; }

while getopts ":i:n:" opt; do
    case "$opt" in
    i)  num=$OPTARG
        ;;
    n)  id=$OPTARG
        ;;
    *) usage
        ;;
    esac
done
shift $((OPTIND-1))

# Force all variables to be used
if [ -z "$num" ]; then
    usage
fi


#192.168.10x.y
IPID=$((20+$id))

#84.x......
PREMAC=`printf '%x\n' $IPID`
MAC=$(printf "84$PREMAC%0.8x\n" "$i" | sed -e 's/../&:/g' -e 's/:$//';)

#Remove old ip pool
rm /home/ubuntu/ip-pool

for ((i=0, j=2, k=$IPID; i < $num; i++, j++))
do
#MAC=$(printf "84$PREMAC%0.8x\n" "$i" | sed -e 's/../&:/g' -e 's/:$//';)
#echo $MAC
# If I is divisible by 250 then we're at the limit of current ip
#if ! ((i % 250)); then
##    echo $k
##    echo 192.168.$k.$j
#fi

if ! ((j % 250)); then
    j=2
    k=$((k + 1))
#    echo $k
#    echo 192.168.$k.$j
fi

#echo 192.168.$k.$j
#echo $MAC

#bash t2-many-ns-launch.sh -n 192.168.$k.$j -m $MAC -i $i
#echo "192.168.$k.$j -m $MAC" >> gen.ip.mac
echo "192.168.$k.$j" >> /home/ubuntu/ip-pool
done

IPLOC=/home/ubuntu/particlem/ip/ip

#Create particle Namespace

VNI=42

##Clean up existing particle container
docker kill particle
docker rm particle
ip netns del particle
####
docker run -itd --name=particle --net=none alpine /bin/sh

#Link to netns so we can use it
dnetns_path=$(docker inspect --format="{{ .NetworkSettings.SandboxKey}}" particle)
ln -sf "$dnetns_path" "/var/run/netns/particle"


$IPLOC link add name vld0 mtu 1500 type veth peer name vgd0 mtu 1500
$IPLOC link set dev vld0 netns quagga
$IPLOC link set dev vgd0 netns particle
$IPLOC netns particle exec quagga $IPLOC link set vld0 master br42
$IPLOC netns particle exec quagga $IPLOC link set vld0 up
# MAC is a fucntion of the id
$IPLOC netns particle exec particle $IPLOC link set dev vgd0 address $MAC
#$IPLOC netns particle exec particle  $IPLOC addr s6particle $num $id add 192.168.23.7/16 dev vgd0
$IPLOC netns particle exec particle  $IPLOC addr s6particle $num  $id  add 192.168.23.7/16 dev vgd0
$IPLOC netns particle exec particle $IPLOC link set vgd0 up



#echo "link add name vethpld$i mtu 1500 type veth peer name vethpgd$i mtu 1500" >> $GENFOLDER/demo$i
#echo "link set dev vethpgd$i address $MAC" >>  $GENFOLDER/demo$i
#echo "link set dev vethpgd$i netns demo$i" >>  $GENFOLDER/demo$i
#echo "link set dev vethpld$i netns quagga" >>  $GENFOLDER/demo$i
#echo "netns exec quagga ip link set vethpld$i master br42" >>  $GENFOLDER/demo$i
#echo "netns exec quagga ip link set vethpld$i up" >>  $GENFOLDER/demo$i
#echo "netns exec demo$i ip link set vethpgd$i up" >>  $GENFOLDER/demo$i
#echo "netns exec demo$i ip addr add 192.168.$k.$j/16 dev vethpgd$i" >>  $GENFOLDER/demo$i
