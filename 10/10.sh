#!/usr/bin/env sh

iter=$1
for i in `seq 1 $2`; do iter=`echo $iter | fold -w 1 | uniq -c | tr  -d ' \n'`; done
echo $iter | tr -d '\n' | wc -c
