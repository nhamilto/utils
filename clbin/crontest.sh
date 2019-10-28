#!/bin/bash


today=$(date "+%Y%m%d")
now=$(date "+%Y%m%d%H%M%W")
data_dir="/home/nwtc/CL51_data/capture_$today/"
cd $data_dir

echo "it appears to be working" >> meta.txt
echo $now >> meta.txt
echo $data_dir >> meta.txt

data_dir="/home/nwtc/CL51_data/capture_$today/tmpdatadir/"
echo "working in: $data_dir" >> meta.txt

cd $data_dir
echo "made it into working dir" >> ../meta.txt

# begin listening for udp packets over ethernet
/usr/sbin/tcpdump -i any -v -w trac.pcap -c10
