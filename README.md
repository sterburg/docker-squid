## Introduction
A simple squid proxy in a docker-image.
Tested on OpenShift.


## Build the Squid container
```shell
oc new-project ops
oc new-app --name=squid https://github.com/sterburg/docker-squid.git
oc new-app sterburg/squid
oc policy add-role-to-group system:image-puller system:authenticated -n ops

wget https://raw.githubusercontent.com/kilimandjango/openshift-squid/master/sites.whitelist.txt 
wget https://raw.githubusercontent.com/kilimandjango/openshift-squid/master/squid.conf 
oc create configmap squid --from-file=/tmp/squid
```

## For every customer
```
cc new-project ${PROJECT}
oc adm new-project ${PROJECT}-ops \
    --node-selector='region=primary,zone=dmz,role=proxy,stage=ota'
oc project ${PROJECT}-ops
oc adm pod-network join-projects --to=${PROJECT} ${PROJECT}-ops
oc new-app --template=ops/squid
oc edit configmap squid                   #change ACL whitelist to your liking
oc delete pod --selector='app=squid'      #to reload the changes
```
