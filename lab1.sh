#!/bin/bash
count=0
common_size=0
find_found=`find $1 -size -$2 -size +$3`
IFS=$'\n'
for file in $find_found
do

let "count = count + 1"
filesize=`wc -c $file | awk '{print $1}'`
let "common_size = common_size + filesize"

done
echo `realpath $1`
echo $count ' files'
echo $common_size ' bytes'
