# Summary

Vagrantfile that defines a Kubernetes cluster using Parallels as the provider. It creates a master node and two worker nodes, each with their own private network IP address. Also provisions the master and worker nodes with the necessary memory and CPU resources, and installs Kubernetes on each node. Additionally, it sets up a synced folder for shared files between the host machine and the cluster.

## Example Usage

`vagrant up`

### Inputs

> provider_type: The type of provider to use for the virtual machines (e.g., "parallels", "virtualbox", "libvirt").

### Flow

- Set the Vagrant box to "bento/debian-12-arm64".
- Define the master node with a hostname and private network IP address.
- Configure the provider for the master node with the specified memory, CPU, and name.
- Provision the master node by running the "install-k8s-master.sh" shell script.
- Iterate over the range of worker nodes (1 to 2) and define each worker node with a hostname and private network IP address.
- Configure the provider for each worker node with the specified memory, CPU, and name.
- Provision each worker node by running the "install-k8s-worker.sh" shell script.
- Set up a synced folder between the host machine and the cluster for shared files.

### Outputs

> A Kubernetes cluster with a master node and two worker nodes, each provisioned with the specified resources and installed with Kubernetes.
