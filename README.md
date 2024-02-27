# BigData Initial


## Usage

1. Copy the compiled jar package of the Flink task to the docker-compose/flink/jobs directory.
2. In the docker-compose directory, start with the command docker compose up -d.

### Debian 12 deploy refer

```
apt install git sudo

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update


git clone https://github.com/datatower-ai/bigdata-initial /data

mkdir -p /data/kafka
mkdir -p /data/mysql
mkdir -p /data/redis
mkdir -p /data/kudu-master
mkdir -p /data/kudu-tserver
mkdir -p /data/datanode
mkdir -p /data/namenode
mkdir -p /data/docker-compose/hdfs/share_hdfs

cd /data/docker-compose
systemctl restart docker
sed -i 's/HOST_IP=/HOST_IP=127.0.0.1/g' .env
docker compose up -d

# wait
# ...

docker ps

# change hdfs/compose.hdfs.yml
# sed -i '5 i\    user: "0:0"' /data/docker-compose/hdfs/compose.hdfs.yml


cd /data

wget https://downloads.apache.org/kafka/3.6.1/kafka_2.13-3.6.1.tgz
# wget http://192.168.8.102:8000/kafka_2.13-3.6.1.tgz
tar xvf kafka_2.13-3.6.1.tgz
apt install default-jdk
/data/kafka_2.13-3.6.1/bin/kafka-topics.sh --create --topic test --bootstrap-server 0.0.0.0:9094 --partitions 3 --replication-factor 1

```

## Todo List

- Plan for creating topics for the first time after Kafka starts.
- Plan for submitting tasks after the Flink cluster starts.
- Solve the problem of DataNode failing to start after mounting the volume.
