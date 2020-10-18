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

GENFOLDER="/home/ubuntu/demogen"
if [ ! -d $GENFOLDER ]; then
	  mkdir -p $GENFOLDER;
fi

rm /home/ubuntu/demogen/demo*

IP=$(ifconfig ens5 | grep "inet " | awk -F'[: ]+' '{ print $3 }')
LAST=`echo $IP | cut -d . -f 4`
PREMAC=`printf '%x\n' $LAST`
#echo $PREMAC

#for ((i=0, j=2; i < $num; i++, j++))
#do
#MAC=$(printf "$PREMAC%0.10x\n" "$i" | sed -e 's/../&:/g' -e 's/:$//';)
##echo $MAC
#sudo bash t2-many-ns-launch.sh -n 192.168.$LAST.$j -m $MAC -i $i
#done

#192.168.10x.y
IPID=$((20+$id))

#84.x......
PREMAC=`printf '%x\n' $IPID`

for ((i=0, j=2, k=$IPID; i < $num; i++, j++))
do
MAC=$(printf "84$PREMAC%0.8x\n" "$i" | sed -e 's/../&:/g' -e 's/:$//';)
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


echo "link add name vethpld$i mtu 1500 type veth peer name vethpgd$i mtu 1500" >> $GENFOLDER/demo$i
echo "link set dev vethpgd$i address $MAC" >>  $GENFOLDER/demo$i
echo "link set dev vethpgd$i netns demo$i" >>  $GENFOLDER/demo$i
echo "link set dev vethpld$i netns quagga" >>  $GENFOLDER/demo$i
echo "netns exec quagga ip link set vethpld$i master br42" >>  $GENFOLDER/demo$i
echo "netns exec quagga ip link set vethpld$i up" >>  $GENFOLDER/demo$i
echo "netns exec demo$i ip link set vethpgd$i up" >>  $GENFOLDER/demo$i
echo "netns exec demo$i ip addr add 192.168.$k.$j/16 dev vethpgd$i" >>  $GENFOLDER/demo$i
done
