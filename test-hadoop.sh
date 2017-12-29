#!/usr/bin/env bash

hadoopver=2.9.0
timenow="`date +%Y%m%d%H%M%S`"
testinput="testhadoop/${timenow}/input"
testoutput="testhadoop/${timenow}/grep_example"

mkdir -p "$testinput"
cp /usr/local/hadoop/etc/hadoop/*.xml "$testinput"
/usr/local/hadoop/bin/hadoop jar "/usr/local/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-${hadoopver}.jar" grep "$testinput" "$testoutput" 'principal[.]*'

if  ls testhadoop/${timenow}/grep_example/part* 1> /dev/null 2>&1; then
    echo "Hadoop mapreduce example has been executed successfully."
	exit 0
else
    echo "Hadoop mapreduce example failed."
	exit 1
fi 

