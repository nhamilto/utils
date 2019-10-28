#!/bin/sh
# part of CL51 data logging script
# Nicholas Hamilton
# 20 September 2019

# find yesterday's temporary folder for today
yesterday=$(date -d "1 day ago" '+%Y%m%d')
cap_dir="/home/nwtc/CL51_data/capture_"$yesterday
cd $cap_dir

# concatenate datastream files
catfile=CL51datastream.$yesterday.txt
/bin/cat streamfiles/* > $catfile

#compress files
/bin/tar -zcvf tracefiles.tar.gz tracefiles
/bin/tar -zcvf streamfiles.tar.gz streamfiles

# /bin/rm -rf tracefiles
# /bin/rm -rf streamfiles