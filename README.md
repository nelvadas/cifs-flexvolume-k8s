# Accessing CIFS/SMB Share from Kubernetes Apps Using FlexVolumes

Flexvolume enables users to write their own drivers and add support for their volumes in Kubernetes.
Flexvolume requires root access on Nodes to install flex driver files.
Starting from k8s 1.13, the recommended approach to support custom storage solutions is to write a custom CSI driver.
In the following blog post series will we cover how CIFS/SMB share can be accessed by both `Flexvolume` and `CSI`


## Prepare a CIFS Server

Download the bertvv.samba role from ansible galaxy and execute the associated test playbook with
a host in your inventory.

```
ansible-galaxy install bertvv.samba
wget -O create-samba-server.yml https://raw.githubusercontent.com/bertvv/ansible-role-samba/docker-tests/test.yml
sed -i.bak "s/role_under_test/bertvv.samba/g" create-samba-server.yml

```

My host file looks like
```
[cifs-server:vars]
ansible_ssh_private_key_file=<!----- Insert your private key here -->
ansible_ssh_user=<!-- Insert your ansible ssh user -->
ansible_user=ec2-user
[cifs-server]
cifs-server-0 ansible_host=34.248.205.56
```


After running the playbook, we have a new Samba server up and running on 34.248.205.56
```
ansible-playbook  -i hosts  create-samba-server.yml  -vv

```


## Building the cifs-flexvol-installer docker image

```
$ docker build --no-cache -t nelvadas/cifs-flexvol-installer:1.0.1 .
..
ip-10-22-8-217.eu-west-1.compute.internal: Successfully built 41b281a266cf
ip-10-22-8-217.eu-west-1.compute.internal: Successfully tagged nelvadas/cifs-flexvol-installer:1.0.1
```

Push the image to Docker hub
```
docker push nelvadas/cifs-flexvol-installer:1.0.1
```

## Deploy the CIFS driver as DaemonSet
```
 kubectl apply -f cifs-flex-ds.yml

kubectl get ds
NAME           DESIRED   CURRENT   READY     UP-TO-DATE   AVAILABLE   NODE SELECTOR   AGE
cifs-flex-ds   3         3         3         3            3           <none>          19h
```

In order to be able to run this drive on master or Docker Universal Control Plane Manager the pod should tolerate the following taints,

```
$ kubectl get ds/cifs-flex-ds -o json | jq  ".spec.template.spec.tolerations"
[
  {
    "effect": "NoSchedule",
    "key": "node-role.kubernetes.io/master"
  },
  {
    "key": "com.docker.ucp.manager",
    "operator": "Exists"
  }
]
```
Once started in privilege mode, the cifs-flex-installer install the driver on each node
```
/usr/libexec/kubernetes/kubelet-plugins/volume/exec/fstab~cifs/cifs
```


## Testing PVC Creation

### Create a secret to access the Share

```
kubectl create secret generic cifs-secret-001 --from-literal username=usr1 --from-literal password="usr1" --type="fstab/cifs" -n cifs-demo-ns
secret/cifs-secret-001 created
```


###
Create a PV pointing on the private share

```
kubectl create -f cifs-flex-pv002.yml
```

Create the associated PVC
```
kubectl create -f cifs-flex-pvc002.yml -n cifs-demo-ns
```

You can see the cifs-flexvol-pvc002` PVC is  created and automatically bound to  cifs-flexvol-pv002` PV.


```
kubectl get pvc -n cifs-demo-ns
NAME                  STATUS    VOLUME               CAPACITY   ACCESS MODES   STORAGECLASS   AGE
cifs-flexvol-pvc002   Bound     cifs-flexvol-pv002   500Mi      RWX                           20s
```


You can also create the busybox in the pod to mount the directory pv-03
```
$ kubectl create -f pod.yaml  -n  cifs-demo-ns
pod/busybox created
EW-MBPt15-2018:cifs-flexvolume-k8s elvadasnonowoguia$ kubectl get pods -n  cifs-demo-ns
NAME      READY     STATUS    RESTARTS   AGE
busybox   1/1       Running   0          8s
```

The container is able to mount the folder and get instant access to existing files.
```
$ kubectl exec -it busybox -n  cifs-demo-ns -- ls /data
toto.txt
```

## Futher Reading

[Migrating Flexvolume to CSI Driver](https://github.com/kubernetes-csi/drivers/tree/master/pkg/flexadapter)
[CSI Driver Developper Documentation ]( https://kubernetes-csi.github.io/docs/)
