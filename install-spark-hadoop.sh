#!/usr/bin/env bash

hadooppack=hadoop-2.9.0
sparkpack=spark-2.2.0
sparkhadooppack="${sparkpack}-bin-hadoop2.7"

hadoopfile="${hadooppack}.tar.gz"
hadoopchkfile="${hadoopfile}.mds"
hadoopsrc="http://apache.melbourneitmirror.net/hadoop/common/${hadooppack}/${hadoopfile}"
hadoopchksrc="https://dist.apache.org/repos/dist/release/hadoop/common/${hadooppack}/${hadoopchkfile}"

sparkfile="${sparkhadooppack}.tgz"
sparkchkfile="${sparkfile}.sha"
sparksrc="http://apache.melbourneitmirror.net/spark/${sparkpack}/${sparkfile}"
sparkchksrc="https://archive.apache.org/dist/spark/${sparkpack}/${sparkchkfile}"

if [ -e "$hadoopfile" ]; then
	echo "$hadoopfile already exists. Skip downloading"
else
	echo "Downloading $hadoopfile from $hadoopsrc"
	wget "$hadoopsrc"
	rm -rf "$hadoopchkfile"
	echo "Downloading $hadoopchkfile from $hadoopchksrc"
	wget "$hadoopchksrc"
fi

if [ -e "$sparkfile" ]; then
	echo "$sparkfile already exists. Skip downloading"
else
	echo "Downloading $sparkfile from $sparksrc"
	wget "$sparksrc"
	rm -rf "$sparkchkfile"
	wget "$sparkchksrc"
fi

if [[ ! -z "$hadooppack" ]] && [[ -d "$hadooppack" ]]; then
	echo "Directory $hadooppack already exists. Removing..."
	rm -rf "$hadooppack"
fi

tar -xzvf "$hadoopfile"

if [[ ! -z "$sparkhadooppack" ]]  && [[ -d "$sparkhadooppack" ]]; then
	echo "Directory $sparkhadooppack already exists. Removing...."
	rm -rf "$sparkhadooppack"
fi

tar -xzvf "$sparkfile"

echo "Moving $hadooppack to /usr/local/..."
hadooplocal="/usr/local/$hadooppack"
if [[ ! -z "$hadooppack" ]] && [[ -d "$hadooplocal" ]]; then
	echo "$hadooplocal already exists. Removing..."
	sudo rm -rf "$hadooplocal"
fi
sudo mv "$hadooppack" /usr/local/
echo "Creating symbolic link from $hadooplocal to /usr/local/hadoop ..."
sudo ln -sf "$hadooplocal/" /usr/local/hadoop

echo "Moving $sparkhadooppack to /usr/local/..."
sparklocal="/usr/local/$sparkhadooppack"
if [[ ! -z "$sparkhadooppack" ]] && [[ -d "$sparklocal" ]]; then
	echo "$sparklocal already exists. Removing..."
	sudo rm -rf "$sparklocal"
fi
sudo mv "$sparkhadooppack" /usr/local/
echo "Creating symbolic link from $sparklocal to /usr/local/spark ..."
sudo ln -sf "$sparklocal/" /usr/local/spark

echo "Setting JAVA_HOME in /usr/local/hadoop/etc/hadoop/hadoop-env.sh"
sudo sed -i.bak '/export JAVA_HOME/c\export JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:bin/java::")' /usr/local/hadoop/etc/hadoop/hadoop-env.sh
