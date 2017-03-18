#!/bin/bash
nowDT=$( date +"%F:%H%:%M:%S" )
sqpDir=/home/cloudera/sqoop
if [ $# -ne 1 ]; then  
 echo "$nowDT : Error -  RunSqoop expects only one input argument...."
 echo "$nowDT : USAGE : RunSqoop.sh <filename>"
exit -1
fi

fileName=$1
fileWithOutExt=${fileName%.*}

cd $sqpDir
. ./$fileName 2> $fileWithOutExt-$nowDT.log | grep -v 'Accumulo'

exit 0;
