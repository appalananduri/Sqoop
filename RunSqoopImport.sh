#!/bin/bash
# author : Venkata Appala Nanduri

HdfsDirTest(){
if $(hadoop fs -test -d $1); then
 echo "$(date +%F:%H:%M:%S) : INFO - $hdfsDir Directory exists ....."
 hdfs dfs -rm -R $1

 if [ $? -eq 0 ] ;  then
  echo "Directory $1 deleted...."
 else 
  echo "unable to delete Directory $1"
 fi

else 
 echo "$(date +%F:%H:%M:%S) : INFO - $hdfsDir Directory does not exists ...."
fi
}


sqpDir=/home/cloudera/sqoop

if [ $# -ne 1 ]; then  
 echo "$(date +%F:%H:%M:%S) : Error - RunSqoop expects only one input argument...."
 echo "$(date +%F:%H%M:%S): USAGE : RunSqoopImport.sh <filename>"
exit -1
fi

fileName=$1

targetdir=`grep target-dir $1 | awk '{print $2}'`
if [ ! -z $targetdir ]; then
 echo "$(date +%F:%H:%M:%S) : INFO - Target Dir : $targetdir" 
 HdfsDirTest $targetdir
fi



warehousedir=`grep warehouse-dir $1 | awk '{print $2}'`
if [ ! -z $warehousedir ] ; then
 echo "$(date +%F:%H:%M:%S) : INFO - Warehouse Dir : $warehousedir"
 HdfsDirTest $warehousedir
fi
 

fileWithOutExt=${fileName%.*}

nowDT=$( date +"%F:%H:%M:%S" )
cd $sqpDir
.  ./$fileName 2> $fileWithOutExt-$nowDT.log | grep -v 'Accumulo'

errorCnt=`grep ERROR $fileWithOutExt-$nowDT.log | wc -l`

if [ $errorCnt -gt 0 ] ; then 
 echo "$nowDT : ERROR - Sqoop import failed, please check the log file $fileWithOutExt.$nowDT.log"
 exit -1 
fi

exit 0;
