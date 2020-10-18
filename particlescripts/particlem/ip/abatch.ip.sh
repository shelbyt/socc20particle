time ./ip link add name vld0 mtu 1500 type veth peer name vgd0 mtu 1500
time ./ip link set dev vld0 netns quagga
time ./ip link set dev vgd0 netns particle
time ./ip netns particle exec quagga ./ip link set vld0 master br42
time ./ip netns particle exec quagga ./ip link set vld0 up
time ./ip netns particle exec particle ./ip link set dev vgd0 address 84:17:84:00:00:20
time ./ip netns particle exec particle  ./ip addr s6particle add 192.168.23.7/16 dev vgd0
time ./ip netns particle exec particle ./ip link set vgd0 up
