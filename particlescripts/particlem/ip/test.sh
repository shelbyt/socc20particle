#Create particle Namespace
docker run -itd --name=particle --net=none alpine /bin/sh

#Link to netns so we can use it
dnetns_path=$(docker inspect --format="{{ .NetworkSettings.SandboxKey}}" particle)
ln -sf "$dnetns_path" "/var/run/netns/particle"

time ./ip link add name vld0 mtu 1500 type veth peer name vgd0 mtu 1500
time ./ip link set dev vld0 netns quagga
time ./ip link set dev vgd0 netns particle
time ./ip netns particle exec quagga ./ip link set vld0 master br42
time ./ip netns particle exec quagga ./ip link set vld0 up
time ./ip netns particle exec particle ./ip link set dev vgd0 address 84:17:84:00:00:20




