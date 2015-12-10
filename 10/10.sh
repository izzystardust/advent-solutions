#!/usr/bin/env sh

iter=$1
for i in `seq 1 $2`; do iter=`echo $iter | sed 's/./& /g' | tr ' ' "\n" | sed '/^$/d' | uniq -c | tr  -d ' \n'`; done
echo $iter | tr -d '\n' | wc -c
