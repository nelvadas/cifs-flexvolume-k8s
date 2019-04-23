# cifs-flexvolume-k8s
Accessing CIFS/SMB Share on Kubernetes Using FlexVolumes 


## Building the cifs-flexvol-installer docker image 

```
$ docker build --no-cache -t nelvadas/cifs-flexvol-installer:1.0.0 .
Sending build context to Docker daemon  65.54kB
ip-10-22-8-217.eu-west-1.compute.internal: Step 1/5 : FROM busyboxip-10-22-8-217.eu-west-1.compute.internal:
ip-10-22-8-217.eu-west-1.compute.internal:  ---> af2f74c517aa
ip-10-22-8-217.eu-west-1.compute.internal: Step 2/5 : WORKDIR .ip-10-22-8-217.eu-west-1.compute.internal:
ip-10-22-8-217.eu-west-1.compute.internal:  ---> Running in fbfbdb53d57d
ip-10-22-8-217.eu-west-1.compute.internal: Removing intermediate container fbfbdb53d57d
ip-10-22-8-217.eu-west-1.compute.internal:  ---> 786862d52255
ip-10-22-8-217.eu-west-1.compute.internal: Step 3/5 : RUN  wget  --no-check-certificate -O /cifs  https://raw.githubusercontent.com/fstab/cifs/master/cifs &&      chmod 755 /cifsip-10-22-8-217.eu-west-1.compute.internal:
ip-10-22-8-217.eu-west-1.compute.internal:  ---> Running in 1fcd5668f8f4
ip-10-22-8-217.eu-west-1.compute.internal: Connecting to raw.githubusercontent.com (151.101.16.133:443)
ip-10-22-8-217.eu-west-1.compute.internal: cifs                 100% |********************************|  5277  0:00:00 ETA
ip-10-22-8-217.eu-west-1.compute.internal: Removing intermediate container 1fcd5668f8f4
ip-10-22-8-217.eu-west-1.compute.internal:  ---> f521e25b7876
ip-10-22-8-217.eu-west-1.compute.internal: Step 4/5 : ADD  deploy.sh /deploy.ship-10-22-8-217.eu-west-1.compute.internal:
ip-10-22-8-217.eu-west-1.compute.internal:  ---> 66736165bb65
ip-10-22-8-217.eu-west-1.compute.internal: Step 5/5 : CMD /bin/sh /deploy.ship-10-22-8-217.eu-west-1.compute.internal:
ip-10-22-8-217.eu-west-1.compute.internal:  ---> Running in 6e097da25263
ip-10-22-8-217.eu-west-1.compute.internal: Removing intermediate container 6e097da25263
ip-10-22-8-217.eu-west-1.compute.internal:  ---> 1cc661d8fc2a
ip-10-22-8-217.eu-west-1.compute.internal: Successfully built 1cc661d8fc2a
ip-10-22-8-217.eu-west-1.compute.internal: Successfully tagged nelvadas/cifs-flexvol-installer:1.0.0
```

Push the image to Docker hub 
```
docker push nelvadas/cifs-flexvol-installer:1.0.0
```

