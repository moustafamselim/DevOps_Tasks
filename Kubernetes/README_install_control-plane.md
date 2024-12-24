# Kubernetes Cluster (Control-plane)
### update & upgrade
    sudo apt update
    sudo apt -y full-upgrade


### check the status
    sudo ufw status
Status: inactive

### Enable time-sync with an NTP server / CP-W
    sudo apt install systemd-timesyncd
    sudo timedatectl set-ntp true

### Check the status
    sudo timedatectl status

### Turn of the swap / CP-W
    sudo swapoff -a
    sudo sed -i.bak -r 's/(.+ swap .+)/#\1/' /etc/fstab
    free -m
    cat /etc/fstab | grep swap

### Configure required kernel modules / CP-W
    sudo vim /etc/modules-load.d/k8s.conf

### Add below content, save and close the file
    overlay
    br_netfilter

### Load above modules to the current session
    sudo modprobe overlay
    sudo modprobe br_netfilter

### Check the status
    lsmod | grep "overlay\|br_netfilter"

### Configure network parameters / CP-W  
### Create k8s.conf file in /etc/sysctl.d 
    sudo vim /etc/sysctl.d/k8s.conf

### Add below content, save and close the file
    net.bridge.bridge-nf-call-ip6tables = 1
    net.bridge.bridge-nf-call-iptables = 1
    net.ipv4.ip_forward = 1

### Apply newly added network params
    sudo sysctl --system

### Install necessary software tools to continue / CP-W
    sudo apt-get install -y apt-transport-https ca-certificates curl \
      gpg gnupg2 software-properties-common
  
### Install Kubernetes Tools & containerd Runtime
### Add Kubernetes repository and keys / CP-W < create the directory >
    sudo mkdir -m 755 /etc/apt/keyrings

### Download and add the k8s repo (v1.31) key / CP-W
    curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.31/deb/Release.key | \
      sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

### Add Kubernetes repo (v1.31) in the source list / CP-W
    echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.31/deb/ /' | \
      sudo tee /etc/apt/sources.list.d/kubernetes.list
  
### Update the package manager and install Kubernetes tools / CP-W
    sudo apt update
    sudo apt-get install -y kubelet kubeadm kubectl
    sudo apt-mark hold kubelet kubeadm kubectl

### Install containerd runtime 
### Add Docker's official GPG key:
    sudo apt-get update
    sudo apt-get install ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

### Add the repository to Apt sources
    echo \
     "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
     $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update

### Install Docker-Containerd
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

### Configure containerd / CP-W
    sudo mkdir -p /etc/containerd
    sudo containerd config default|sudo tee /etc/containerd/config.toml

### Edit [ SystemdCgroup = true ]
    sudo nano /etc/containerd/config.toml   

### restart & enable
    sudo systemctl restart containerd
    sudo systemctl enable containerd
    systemctl status containerd

### Setup crictl
    sudo crictl ps
    sudo apt install cri-tools

### Create crictl.yaml file in /etc/
    sudo vim /etc/crictl.yaml

### Copy & Past 
    runtime-endpoint: unix:///run/containerd/containerd.sock
    image-endpoint: unix:///run/containerd/containerd.sock
    timeout: 2
    debug: true # <- if you don't want to see debug info you can set this to false
    pull-image-on-create: false

### Enable kubelet service 
    sudo systemctl enable kubelet
    sudo crictl ps

### pull images 
    sudo kubeadm config images pull --cri-socket unix:///var/run/containerd/containerd.sock
    sudo crictl images

                          
### Initialize the control-plane 
    sudo kubeadm init \
      --pod-network-cidr=10.244.0.0/16 \
      --cri-socket unix:///var/run/containerd/containerd.sock \
      --v=5
                                                 
### After that, 3 commands will appear, as is clear, that must be executed
###### *mkdir -p $HOME/.kube*
###### *sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config*
###### *sudo chown $(id -u):$(id -g) $HOME/.kube/config*

    kubectl get nodes

### Add network
    kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.29.1/manifests/tigera-operator.yaml
    curl https://raw.githubusercontent.com/projectcalico/calico/v3.29.1/manifests/custom-resources.yaml -O

### Edit CIDR to < 10.244.0.0/16>
    nano custom-resources.yaml

### Apply
    kubectl create -f custom-resources.yaml
    watch kubectl get pods -A
    watch kubectl get pods -n calico-system
    kubectl get nodes        

### Install Helm 
    curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
    sudo apt-get install apt-transport-https --yes
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
    sudo apt-get update
    sudo apt-get install helm

### Install ingress-controller
    helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
    helm repo update

### First you must finish installing the worker-node.
### To add a worker-node, execute the following command. A new command will appear that must be executed on the worker-node                    
    kubeadm token create --print-join-command

### Create ns ingress-nginx 
    kubectl create ns ingress-nginx



### install nginx-ingress
    helm install nginx-ingress ingress-nginx/ingress-nginx --namespace ingress-nginx --set controller.service.type=NodePort --set controller.service.nodePorts.http=30080 --set controller.service.nodePorts.https=30443 --set controller.admissionWebhooks.enabled=true --set controller.admissionWebhooks.patch.enabled=true

### Edit ingressclassFile .
    kubectl edit ingressclass nginx

### Add this line under < annotations:>
    ingressclass.kubernetes.io/is-default-class: "true"

                                                                                                                               










