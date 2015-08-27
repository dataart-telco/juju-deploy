#!/bin/bash

#Install juju-deployer package
sudo apt-get install -y juju-deployer

#Deploy the bundle
#TODO: soft link to bundle to stable and bleeding edge charm revisions

set -e

export JUJU_REPOSITORY=$PWD/charms 

#if in need for more power#
juju set-constraints 'instance-type=m3.medium'

juju-deployer -c bundle-restcomm.yaml
