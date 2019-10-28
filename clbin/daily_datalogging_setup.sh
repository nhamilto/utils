#!/bin/sh
# part of CL51 data logging script
# Nicholas Hamilton
# 19 September 2019

# make temporary folder for today
today=$(date "+%Y%m%d")

# make a directory for today's data
data_dir="/home/nwtc/CL51_data/capture_"$today
/bin/mkdir -p -m 777 $data_dir
cd $data_dir

# make subfolders
/bin/mkdir -p -m 777 streamfiles
/bin/mkdir -p -m 777 tracefiles
