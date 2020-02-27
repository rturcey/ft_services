# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    setup.sh                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: rturcey <marvin@42.fr>                     +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/02/16 11:29:15 by rturcey           #+#    #+#              #
#    Updated: 2020/02/16 11:29:18 by rturcey          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!/bin/sh

# ****************************** checking $USER ****************************** #

if [ -z "$USER" ]; then
	export USER=$(whoami)
fi

mkdir -p /goinfre/$USER

# ****************************** checking brew ******************************* #

which -s brew

if [ $? != 0 ] ; then
	rm -rf $HOME/.brew
	git clone --depth=1 https://github.com/Homebrew/brew $HOME/.brew
	echo 'export PATH=$HOME/.brew/bin:$PATH' >> $HOME/.zshrc
	source $HOME/.zshrc
fi

brew update

# ******************************* init docker ******************************** #

sh srcs/init_docker.sh

# ***************************** checking minikube **************************** #

which -s minikube

if [ $? != 0 ] ; then
	brew install minikube
fi

MINIKUBE_HOME=/goinfre/$USER
export MINIKUBE_HOME

# ***************************** checking kubectl ***************************** #

which -s kubectl

if [ $? != 0 ] ; then
	brew install kubectl
fi

# ************************* minikube start & addons ************************** #

minikube config set vm-driver virtualbox
minikube delete
minikube start --extra-config=apiserver.service-node-port-range=1-30000 --extra-config=kubelet.authorization-mode=AlwaysAllow
eval $(minikube docker-env)

minikube addons enable ingress
minikube addons enable dashboard
minikube addons enable metrics-server

MINIKUBE_IP=$(minikube ip)
export MINIKUBE_IP

# ****************************** build & apply ******************************* #

docker build -t nginx srcs/nginx/
docker build -t mysql srcs/mysql/
docker build -t wordpress srcs/wordpress/

cp srcs/originals/telegraf.yaml srcs/telegraf.yaml
sed -i '' "s/MINIKUBE_IP/$MINIKUBE_IP/g" srcs/telegraf.yaml

kubectl apply -f ./srcs/

# ******************************* import .sql ******************************** #

cp srcs/originals/wordpressdb.sql srcs/mysql/wordpressdb.sql
sed -i '' "s/MINIKUBE_IP/$MINIKUBE_IP/g" srcs/mysql/wordpressdb.sql

while [ $(kubectl get pods -l app=mysql -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]; do
	sleep 5;
done

sleep 20

kubectl exec -i $(kubectl get pods | grep mysql | cut -d" " -f1) -- mysql wordpressdb -u root < srcs/mysql/wordpressdb.sql

# ***************************** import influxdb ****************************** #

cp srcs/originals/setdb.sh srcs/setdb.sh
sed -i '' "s/MINIKUBE_IP/$MINIKUBE_IP/g" srcs/setdb.sh

while [ $(kubectl get pods -l app=grafana -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]; do
	sleep 5;
done

sleep 20

sh srcs/setdb.sh










