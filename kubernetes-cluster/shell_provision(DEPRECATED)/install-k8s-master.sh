# install-k8s-master.sh
print() {
    local input_string=$1
    local length=${#input_string}
    local border=$(printf '=%.0s' $(seq 1 $((length+4))))
    echo "${border}"
    echo "= ${input_string} ="
    echo "${border}"
}
log() {
    local input_string=$1
    local length=${#input_string}
    local border=$(printf '=%.0s' $(seq 1 $((length+6)))) 
    border=${border//=/-} # replace = with -
    echo "${border}"
    echo "└─ ${input_string} ─┘"
    echo "${border}"
}


print "Turning off swap"
sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
print "Setting Up Env for containerd"
cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf 
overlay 
br_netfilter
EOF
sudo modprobe overlay
sudo modprobe br_netfilter
cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-k8s.conf
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1 
net.bridge.bridge-nf-call-ip6tables = 1 
EOF
log "Successfully turned off swap!"

print "Installing containerd"
sudo sysctl --system
sudo apt update
sudo apt -y install containerd
# configure containerd to work with kubernetes
print "Configuring containerd"
containerd config default | sudo tee /etc/containerd/config.toml >/dev/null 2>&1
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml

print "Restarting containerd"
sudo systemctl restart containerd
sudo systemctl enable containerd
log "Containerd setup and ready!"

print "Installing Kubernetes"
# Install Kubernetes components on master
sudo apt-get update
# apt-transport-https may be a dummy package; if so, you can skip that package
sudo apt install gnupg gnupg2 curl software-properties-common -y
# TODO: edit this to take in a variable for release. 
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
# This overwrites any existing configuration in /etc/apt/sources.list.d/kubernetes.list
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
log "Kubernetes installed and ready!"

print "Creating control plane"
sudo kubeadm init --control-plane-endpoint=192.168.50.10
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
log "Control Plane installed and ready!"

print "Creating join file in shared drive" 
sudo kubeadm token create --print-join-command > /kube/shared/join_command.txt
file_content=$(cat /kube/shared/join_command.txt)
log "$file_content"
# Install Pod network on master
sudo kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
