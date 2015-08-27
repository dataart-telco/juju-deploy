#!/bin/bash

#Install juju-deployer package
sudo apt-get install -y juju-deployer

#Deploy the bundle
#TODO: soft link to bundle to stable and bleeding edge charm revisions
set -e

export JUJU_REPOSITORY=$PWD/charms 

#if in need for more power#
juju set-constraints 'instance-type=m3.medium'


# Prepare bundlet template file
# Create machines in one zone 

kubeMasterId=`juju add-machine zone=us-east-1b 2>&1 | sed 's/created machine //'`
kubeDockerId=$(juju add-machine zone=us-east-1b 2>&1 | sed 's/created machine //')
kubeEtcdId=$(juju add-machine zone=us-east-1b 2>&1 | sed 's/created machine //')

# patch template file
sed "s/MACHINE_KUBE_MASTER_ID/"$kubeMasterId"/g" kubernetes-bundle.yaml.in > kubernetes-bundle-patched.yaml
sed -i "s/MACHINE_KUBE_DOCKER_ID/"$kubeDockerId"/g" kubernetes-bundle-patched.yaml
sed -i "s/MACHINE_KUBE_ETCD_ID/"$kubeEtcdId"/g" kubernetes-bundle-patched.yaml

# start deploy with patched file 
juju-deployer -c kubernetes-bundle-patched.yaml

