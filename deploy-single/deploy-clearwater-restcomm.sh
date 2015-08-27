#!/bin/bash

#Install juju-deployer package
sudo apt-get install -y juju-deployer

#Deploy the bundle
#TODO: soft link to bundle to stable and bleeding edge charm revisions

set -e

export JUJU_REPOSITORY=$PWD/charms 

#if in need for more power#
juju set-constraints 'instance-type=m1.medium'
#juju machine add zone=us-east-1a
#juju machine add zone=us-east-1a
#juju machine add zone=us-east-1a
#juju machine add zone=us-east-1a
#juju machine add zone=us-east-1a
#juju machine add zone=us-east-1a
#juju machine add zone=us-east-1a
#juju machine add zone=us-east-1a
#juju machine add zone=us-east-1a
#juju machine add zone=us-east-1a

juju-deployer  -c clearwater-restcomm.yaml -c bundle-config.yaml  clearwater
