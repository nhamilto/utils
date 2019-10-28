cl data logging setup tools

refs
----------
https://help.ubuntu.com/lts/serverguide/network-configuration.html
https://www.swiftstack.com/docs/install/configure_networking.html

apt things
----------
apt-get install $(grep -vE "^\s*#" filename  | tr "\n" " ")

sytem things
----------------
crontab -l > /some/shared/location/crontab.bak
crontab /some/shared/location/crontab.bak

As mentioned by others, Wi-Fi connection files in system-connections directory have the interface MAC address included. This need to match your current setup hence the procedure is:

    copy all files from old machine to new machine from/to directory:

    /etc/NetworkManager/system-connections

    change MAC address entry in each file from old MAC to new MAC. As root:

    cd /etc/NetworkManager/system-connections
    sed -i -e 's/<old mac>/<new mac>/ *

    Just in case, restart network manager:

    systemctl restart NetworkManager



Output of ifconfig
--------------------
nwtc@nwtc-cl51-datalogger:~/Documents/utils$ ifconfig
enp1s0    Link encap:Ethernet  HWaddr 2c:94:64:01:df:2c  
          inet addr:192.168.127.100  Bcast:192.168.127.255  Mask:255.255.255.0
          UP BROADCAST MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)
          Memory:90500000-9057ffff 

enp2s0    Link encap:Ethernet  HWaddr 2c:94:64:01:df:2d  
          UP BROADCAST MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)
          Memory:90400000-9047ffff 

lo        Link encap:Local Loopback  
          inet addr:127.0.0.1  Mask:255.0.0.0
          inet6 addr: ::1/128 Scope:Host
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:1991 errors:0 dropped:0 overruns:0 frame:0
          TX packets:1991 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:484996 (484.9 KB)  TX bytes:484996 (484.9 KB)

wlx9cefd5fc739c Link encap:Ethernet  HWaddr 9c:ef:d5:fc:73:9c  
          inet addr:10.10.25.237  Bcast:10.10.31.255  Mask:255.255.248.0
          inet6 addr: fe80::d0d8:70e3:28ad:1908/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:10583 errors:0 dropped:0 overruns:0 frame:0
          TX packets:8796 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:11154418 (11.1 MB)  TX bytes:1213622 (1.2 MB)


