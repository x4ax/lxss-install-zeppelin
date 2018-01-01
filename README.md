# lxss-install-zeppelin
Step by step guide on how to install Apache Zeppelin 0.7.3 on Linux subsystem for Windows 10 (WSL). 

Includes scripts to download and install Apache Hadoop 2.9.0 and Spark 2.2.0  

__Note:__ These instructions describe the installation steps for the legacy WSL/lxss. Under the Fall Creators Update of Windows 10 (1709), the process will be slightly different.

After installation is complete, Zeppelin 0.7.3 is launched on port 8891, zeppelin daemon is available as:
```bash
/usr/local/zeppelin/bin/zeppelin-daemon.sh start
/usr/local/zeppelin/bin/zeppelin-daemon.sh stop
``` 

# Zeppelin 0.7.3 on WSL step by step:

## 1 Check/install git 
```bash
$ sudo apt-get update
$ sudo apt-get -y -qq install git
$ git --version
```

## 2 Checkout /x4ax/lxss-install-zeppelin repo from GitHub
```bash
$ mkdir ~/x4ax
$ cd ~/x4ax
$ git clone https://github.com/x4ax/lxss-install-zeppelin.git
$ cd lxss-install-zeppelin
```
## 3 Install Java 8
```bash
~/x4ax/lxss-install-zeppelin $ ./install-java.sh
```
- Installs OpenJDK 8 using apt-get.

## 4 Install Hadoop 2.9.0 and Spark 2.2.0 - Hadoop 2.7 
```bash
~/x4ax/lxss-install-zeppelin $ ./install-spark-hadoop.sh
```

- Downloads the hadoop bin package from http://www.apache.org/dyn/closer.cgi/hadoop/common/hadoop-2.9.0/hadoop-2.9.0.tar.gz
- Downloads the spark bin package from https://www.apache.org/dyn/closer.lua/spark/spark-2.2.0/spark-2.2.0-bin-hadoop2.7.tgz
- Unpacks the downloaded hadoop and spark packages
- Moves the extracted hadoop folder to ```/usr/local```
- Creates the symlink ```/usr/local/hadoop-2.9.0 -> /usr/local/hadoop```
- Moves the extracted spark folder to ```/usr/local```
- Creates the symlink ```/usr/local/spark-2.2.0-bin-hadoop2.7 -> /usr/local/spark```
- Modifies ```/usr/local/hadoop/etc/hadoop/hadoop-env.sh```
```bash
export JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:bin/java::")
```

## 5 Test hadoop (using mapreduce "grep" example) 
https://github.com/apache/hadoop/blob/trunk/hadoop-mapreduce-project/hadoop-mapreduce-examples/src/main/java/org/apache/hadoop/examples/Grep.java
```bash
~/x4ax/lxss-install-zeppelin $ ./test-hadoop.sh
```
- Creates ```testhadoop/${timenow}/input``` folder in PWD, copies the xml files from ```/usr/local/hadoop/etc/hadoop/``` to be used as the input for the test mapreduce job
- Runs the mapreduce "grep" example
- Stores results in ```testhadoop/${timenow}/grep_example``` folder, expecting any ```grep_example/part*```  as __Success__

## 6 Test spark (using SparkPi example) 
https://github.com/apache/spark/blob/branch-2.2/examples/src/main/scala/org/apache/spark/examples/SparkPi.scala
```bash
~/x4ax/lxss-install-zeppelin $ ./test-spark.sh
```
- Runs the SparkPI example, expecting "Pi is roughly ... " in output as __Success__ 

## 7 Install Zeppelin 0.7.3 and launch it on port 8891
```bash
~/x4ax/lxss-install-zeppelin $ ./install-zeppelin.sh
```

- Downloads the zeppelin bin package from http://www.apache.org/dyn/closer.cgi/zeppelin/zeppelin-0.7.3/zeppelin-0.7.3-bin-all.tgz
- Unpacks the downloaded zeppelin package
- Moves the extracted zeppelin folder to ```/usr/local```
- Creates the symlink ```/usr/local/zeppelin-0.7.3 -> /usr/local/zeppelin```
- Modifies ```/usr/local/zeppelin/conf/zeppelin-env.sh```
```bash
export JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:bin/java::")
export SPARK_HOME=/usr/local/spark
```
- Modifies ```/usr/local/zeppelin/conf/zeppelin-site.xml```  
```txt
zeppelin.server.port=8891
```
- Launches Zeppelin

# Addendum. WSL

## How to install the Windows Subsystem for Linux
https://docs.microsoft.com/en-us/windows/wsl/install-win10
 
## Full lxss (legacy WSL) reinstall
In the explanation below we will use:

```lnx-user-name``` - to refer to a regular lxss user (other than root)

In Windows cmd with elevated permissions  
```bash
> lxrun /uninstall /full /y
> rm -rf %USERPROFILE%\AppData\Local\lxss
> lxrun /install /y
> lxrun /setdefaultuser lnx-user-name
... enter password
```

## How to reset lxss (legacy WSL) user password

In Windows cmd with elevated permissions, set default lxss user to root: 
```bash
> lxrun /setdefaultuser root
```
in bash, change password of the regular lxss user
```bash
$ passwd lnx-user-name
```
in Windows cmd or PowerShell, set default lxss user to the regular user:
```bash
> lxrun /setdefaultuser lnx-user-name
```

 