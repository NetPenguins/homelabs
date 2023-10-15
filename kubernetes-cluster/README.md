# Summary

Vagrantfile that defines a Kubernetes cluster It creates a master node and two worker nodes, each with their own private network IP address. Also provisions the master and worker nodes with the necessary memory and CPU resources, and installs Kubernetes on each node. Additionally, it sets up a [kubernetes dashboard](https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/) on the master node for UI management of the cluster.

> Ansible is being used for its [idempotency](https://docs.ansible.com/ansible/latest/reference_appendices/glossary.html#term-Idempotency)

> [!IMPORTANT]
> Before running this, ensure a solid understanding of what the [Vagrantfile](./Vagrantfile) is going to do. It is particulary important to review the resource allocations and ensure your host machine can handle it. 

## Example Usage

>[!NOTE]
> In order for the dashboard to be available the master node must first finish provisioning. Once a worker is provisioned the dashboard will be assigned to it. This can take a bit of time to complete depending on your hardware. 

```sh
vagrant up master && vagrant up
```

>[!INFO]
> The worker nodes have a vagrant trigger assigned to them for `worker.trigger.before :destroy`. This trigger is used to cleanly tear down the worker nodes by unregistering them from the cluster before destroying the VM.

### Inputs

> provider_type: The type of provider to use for the virtual machines (e.g., "parallels", "virtualbox", "libvirt").

### Outputs

> A Kubernetes cluster with a master node and two worker nodes, each provisioned with the specified resources and installed with Kubernetes.
