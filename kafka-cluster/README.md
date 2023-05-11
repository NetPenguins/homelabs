# Kafka Cluster
### Pre-reqs
- Vagrant - https://developer.hashicorp.com/vagrant/docs/installation
- Ansible - https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html
- VirtualBox, VMWare, Parrallels etc.

### Getting Started
Run the following from the `kafka-cluster` directory to get up and running.

```sh
vagrant up
```

This will run through the creation of the following vms: 

- zookeeper - 192.168.50.11
- kafka1 - 192.168.50.21
- kafka2 - 192.168.50.22
- kafka3 - 192.168.50.23

To further tune the configurations of these machines change the corresponding `server-{boxid}.properties` file in `/files` 
#### Confirmation
To confirm its all working as expected run the following: 

**In kafka2 and kafka3:**
```sh
./bin/kafka-console-consumer.sh --topic my-topic --bootstrap-server localhost:9092 --from-beginning
```

**In kafka1:**
```sh
./bin/kafka-topics.sh --create --topic my-topic --partitions 3 --replication-factor 3 --bootstrap-server localhost:9092
./bin/kafka-console-producer.sh --topic my-topic --bootstrap-server localhost:9092 # <-- type messages when the shell opens, should see in kafka2 and 3 
```

