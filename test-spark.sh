#!/usr/bin/env bash
echo "Running spark SparkPi example. Expecting string [Pi is roughly 3.xyz] in output"
if /usr/local/spark/bin/run-example SparkPi | grep "Pi is roughly "; then
  echo "Spark example has been executed successfully"
  exit 0
else
  echo "Spark example failed!"
  exit 1
fi
