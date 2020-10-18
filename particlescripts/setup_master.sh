#!/bin/bash

#if [ ! "$(docker ps -q -f name=master)" ]; then
    docker kill master
    docker rm master
    # run your container
    #docker  run --name master --net=none -d alpine tail -f /dev/null
    #docker  run --name master --ulimit nofile=90000:90000 --pids-limit 5000 --privileged --cap-add=ALL  --net=none -d dellabetta/tcpserver tail -f /dev/null
    #docker  run --name master --net=none -d dellabetta/tcpserver tail -f /dev/null
    docker  run --privileged --pids-limit -1 --cap-add=NET_ADMIN --name master --net=none -d ubuntu_master tail -f /dev/null
    # Setup IPs
            dnetns_path=$(docker inspect --format="{{ .NetworkSettings.SandboxKey}}" master)
            ln -sf "$dnetns_path" "/var/run/netns/master"
            ip --batch master.ip 
    
    docker  cp gettime master:/
    #docker  cp limits.conf master:/etc/security/limits.conf
    #docker  exec master mkdir /lib64
    #docker  exec master mkdir lib64
    #docker  exec master ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2
    #docker  exec -d master nc -l -k -p 5000 -e ./gettime
    docker  exec -d master tcpserver -b 5000 -c 5000 192.168.250.250 5000 /gettime
    #docker exec -d master nc -klw 0 -m 50000 -p 5000 -e ./gettime
#fi
