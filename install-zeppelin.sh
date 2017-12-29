#!/usr/bin/env bash

# =============================================================================
#
# Installs Zeppelin on Linux Subsystem on Windows 10 (lxss)
#
# Prerequisites: 
#	1) Java in /usr/bin/java
#	2) Spark in /usr/local/spark
#
# - Attempt to stops zeppelin daemon
# - Downloads zeppelin bin to PWD (skips download if tar file already exists)
# - Extracts in PWD
# - Moves extracted zeppelin-x.y.z folder to /usr/local/
# - Creates symbolic link /usr/local/zeppelin-x.y.z -> /usr/local/zeppelin/ (deletes previous link if exists)
# - Updates zeppelin-env.sh setting:
#		JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:bin/java::")
#		SPARK_HOME=/usr/local/spark
# - Updates zeppelin-site.xml setting port to 8891 (as in AWS)
# - Starts zeppelin daemon 
#
# =============================================================================

zepversion=zeppelin-0.7.3

zeppack="${zepversion}-bin-all"
zepfile="${zeppack}.tgz"
zepsrc="http://apache.melbourneitmirror.net/zeppelin/${zepversion}/${zepfile}"

zeplocal="/usr/local/$zeppack"
zepenv="/usr/local/zeppelin/conf/zeppelin-env.sh"
zepsite="/usr/local/zeppelin/conf/zeppelin-site.xml"

if [[ -x /usr/local/zeppelin/bin/zeppelin-daemon.sh ]]; then
	echo "Stopping existing Zeppelin"
	/usr/local/zeppelin/bin/zeppelin-daemon.sh stop
fi

if [ -e "$zepfile" ]; then
  echo "$zepfile already exists. Skip downloading"
else
  echo "Downloading $zepfile from $zepsrc"
  wget "$zepsrc"
fi

if [[ ! -z "$zeppack" ]]  && [[ -d "$zeppack" ]]; then
  echo "Directory $zeppack already exists. Removing...."
  rm -rf "$zeppack"
fi

echo "Unpacking $zepfile ..."
tar -xzf "$zepfile"

echo "Moving $zeppack to /usr/local/..."
if [[ ! -z "$zeppack" ]] && [[ -d "$zeplocal" ]]; then
  echo "$zeplocal already exists. Removing..."
  sudo rm -rf "$zeplocal"
fi
sudo mv "$zeppack" /usr/local/

echo "Creating symbolic link from $zeplocal to /usr/local/zeppelin ..."

if [[ -e "/usr/local/zeppelin" ]]; then
  echo "/usr/local/zeppelin already exists. Removing..."
  sudo rm -rf /usr/local/zeppelin
fi
sudo ln -s "$zeplocal/" /usr/local/zeppelin

cp -f /usr/local/zeppelin/conf/zeppelin-env.sh.template $"$zepenv"
cp -f /usr/local/zeppelin/conf/zeppelin-site.xml.template "$zepsite"

echo "Setting JAVA_HOME in $zepenv"
sudo sed -i '/export JAVA_HOME/c\export JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:bin/java::")' "$zepenv"

echo "Setting SPARK_HOME in $zepenv"
sudo sed -i '/export SPARK_HOME/c\export SPARK_HOME=/usr/local/spark' "$zepenv"

echo "Setting ZEPPELIN_PORT=8891 in $zepsite"
sudo sed -i '/<name>zeppelin.server.port<\/name>/{n;s/  <value>.*<\/value>/  <value>8891<\/value>/}' "$zepsite"

/usr/local/zeppelin/bin/zeppelin-daemon.sh start

echo "http://localhost:8891"