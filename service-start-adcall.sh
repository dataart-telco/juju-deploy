#set -x

#juju run 'rm -rf vas-demo-docker-repo; git clone https://github.com/taddemo2015/vas-demo-docker-repo.git' --service kubernetes-master
juju run 'cd vas-demo-docker-repo; ./restart-adcall-prod-juju.sh' --service kubernetes-master

