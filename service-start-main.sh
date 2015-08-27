#!/bin/bash

#debug only
#set -x

juju run 'mkdir -p /var/run/kubernetes-master; echo "tads2015dataart@gmail.com royhpfahquozbxge"> /var/run/kubernetes-master/mail-acc' --service kubernetes-master
juju run 'rm -rf vas-demo-docker-repo; git clone https://github.com/taddemo2015/vas-demo-docker-repo.git' --service kubernetes-master
juju run 'cd vas-demo-docker-repo; ./deploy-prod-juju.sh' --service kubernetes-master
juju action do kubernetes-master/0 create-service
