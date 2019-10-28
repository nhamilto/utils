#!/bin/sh
# part of CL51 data logging script
# Nicholas Hamilton
# 20 September 2019


# make a directory for today's data
today=$(date "+%Y%m%d")
data_dir="/home/nwtc/CL51_data/capture_"$today
mkdir -p -m 777 $data_dir
cd $data_dir

# make subfolders
mkdir -p -m 777 streamfiles
mkdir -p -m 777 tracefiles
mkdir -p -m 777 tmpdatadir
cd tmpdatadir
pwd

scantime=${1:-3600}
nfiles=${2:-600}
roll_sec=$((scantime / nfiles))
echo "reading data for" "$scantime" "seconds in" "$nfiles" "chunks of" "$roll_sec" "seconds each." 

tcpdump -i enp1s0 udp -w trace.%Y%m%d%H%M%S.pcap -W $nfiles -G $roll_sec

for capfile in trace*
do
    udpstream=udpstream.$(echo $capfile| cut -d'.' -f 2).txt
	tshark -r $capfile -z "follow,udp,ascii,192.168.127.254:4001,192.168.127.100:4001" > $udpstream
    ## clean text
    # remove lines up to node communication line
    sed -n '/Node 1: 192.168.127.100:4001/,$p' $udpstream > test.txt
    # remove first and last lines
    sed '1d;$d' test.txt > test2.txt
    # remove packet data length lines
    sed '/1024/d' test2.txt > test.txt
    # add lines to separate scans
    sed '/.CL010316./i \ ' test.txt > $udpstream
    rm -f test*
done

current_time=$(date "+%Y%m%d-%H%M%S")
catfile=udp.$current_time.txt
cat udpstream* > $catfile

# move files to the appropriate places
cp $catfile ../streamfiles/.
cp trace* ../tracefiles/.

chmod -R 666 *

# cleanup
cd ../
rm -rf tmpdatadir