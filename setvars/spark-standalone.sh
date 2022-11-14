export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-11.0.ea.28-7.el7.x86_64
export SPARK_HOME=$HOME/.local/mapreduce/spark-current
export SPARK_CONF_DIR=$HOME/.local/mapreduce/spark-on-slurm
export PYTHONPATH=$SPARK_HOME/python:$SPARK_HOME/python/lib/py4j-0.10.9.5-src.zip:$PYTHONPATH
export PATH=$JAVA_HOME/bin:$SPARK_HOME/bin:$PATH
