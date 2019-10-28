#!/bin/sh
# part of CL51 data logging script
# Nicholas Hamilton
# 20 September 2019



# make a directory for today's data
today=$(date "+%Y%m%d")
dir="/home/nwtc/CL51_data/capture_$today"
if [ ! -d $dir ]; then
  echo "$dirdoes not exist."
  /home/nwtc/bin/daily_datalogging_setup.sh
fi

now=$(date "+%Y%m%d%H%M%S")
data_dir="/home/nwtc/CL51_data/capture_$today/tmpdatadir$now/"
/bin/mkdir $data_dir
cd $data_dir
echo "right now: $now" >> meta.txt
echo "working in: $data_dir" >> meta.txt

# parse input options
roll_sec=''
nfiles=''
interface='enp1s0'

print_usage() {
  printf "Usage: -r roll_sec -n nfiles"
}

while getopts 'r:n:i:' flag; do
  case "${flag}" in
    r) roll_sec="${OPTARG}" ;;
    n) nfiles="${OPTARG}" ;;
    i) interface="${OPTARG}" ;;
    # s) scantime="${OPTARG}" ;;
    *) print_usage
       exit 1 ;;
  esac
done

scantime=$((roll_sec * nfiles))
echo "reading data for $scantime seconds in $nfiles chunks of $roll_sec seconds each." >> meta.txt

# begin listening for udp packets over ethernet
/usr/sbin/tcpdump -i $interface udp -w trace.%Y%m%d%H%M%S.pcap -W $nfiles -G $roll_sec

echo "changing permissions for tracefiles" >> meta.txt
chmod 666 trace*
echo "tracefiles:" >> meta.txt
/bin/ls -lha trace* >> meta.txt

for capfile in trace*
do
  echo "following udp stream in $capfile" >> meta.txt
  UFile=udpstream.$(echo $capfile| cut -d'.' -f 2).txt
	/usr/bin/tshark -r $capfile -z "follow,udp,ascii,192.168.127.254:4001,192.168.127.100:4001" > $UFile
  ## clean text
  # remove lines up to node communication line
  /bin/sed -n '/Node 1: 192.168.127.100:4001/,$p' $UFile > test.txt
  # remove first and last lines
  /bin/sed '1d;$d' test.txt > test2.txt
  # remove packet data length lines
  /bin/sed '/1024/d' test2.txt > test.txt
  # add lines to separate scans
  /bin/sed '/.CL010316./i \ ' test.txt > $UFile
  rm -f test*
done

echo "changing permissions for udp files" >> meta.txt
chmod 666 udp*
echo "udp files:" >> meta.txt
/bin/ls -lha udp* >> meta.txt

current_time=$(date "+%Y%m%d-%H%M%S")
catfile=udp.$current_time.txt
/bin/cat udpstream* > $catfile

# ensure that everyone has rw priveleges
chmod 666 *

# move files to the appropriate places
/bin/cp -p $catfile ../streamfiles/.
/bin/cp -p trace* ../tracefiles/.

# cleanup
cd ../
/bin/rm -rf $data_dir