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

green=$'\033[1;92m'
red=$'\033[1;91m'
cend=$'\033[0m'

echo "${red}[!] PLEASE NOTICE THAT DOCKER SHOULD BE RUNNING NOW [!]${cend}"

# ****************************** checking $USER ****************************** #

if [ -z "$USER" ]; then
	echo 'export $USER=$(whoami)' >> ~/.zshenv
	source ~/.zshenv
fi

mkdir -p /goinfre/$USER

# ****************************** checking brew ******************************* #

which -s brew 

if [ $? != 0 ] ; then
	echo "${green}Installing brew...${cend}"
	rm -rf $HOME/.brew
	git clone --depth=1 https://github.com/Homebrew/brew $HOME/.brew
	echo 'export PATH=$HOME/.brew/bin:$PATH' >> $HOME/.zshrc
	source $HOME/.zshrc
fi

echo "${green}Updating brew...${cend}"
brew update

# ***************************** checking minikube **************************** #

if [ -d /goinfre/$USER/.minikube ]; then
	rm -rf /goinfre/$USER/.minikube
fi

echo 'export MINIKUBE_HOME=/goinfre/$USER' >> ~/.zshenv
source ~/.zshenv

which -s minikube

if [ $? != 0 ] ; then
	echo "${green}Installing minikube...${cend}"
	brew install minikube
fi

# ***************************** checking kubectl ***************************** #

which -s kubectl

if [ $? != 0 ] ; then
	echo "${green}Installing kubectl...${cend}"
	brew install kubectl
fi

# ************************* minikube start & addons ************************** #

echo "${green}Starting minikube...${cend}"
minikube config set vm-driver virtualbox
minikube delete
minikube start --bootstrapper=kubeadm --extra-config=apiserver.service-node-port-range=1-30000
eval $(minikube docker-env)

minikube addons enable ingress
minikube addons enable dashboard
minikube addons enable metrics-server

# ****************************** build & apply ******************************* #

echo "${green}Building...${cend}"

cp srcs/originals/index.html srcs/nginx/index.html
sed -i '' "s/MINIKUBE_IP/$(minikube ip)/g" srcs/nginx/index.html

docker build -t nginx srcs/nginx/

cp srcs/originals/wordpressdb.sql srcs/mysql/wordpressdb.sql
sed -i '' "s/MINIKUBE_IP/$(minikube ip)/g" srcs/mysql/wordpressdb.sql

docker build -t mysql srcs/mysql/
docker build -t wordpress srcs/wordpress/

cp srcs/originals/setssl.sh srcs/ftps/setssl.sh
sed -i '' "s/MINIKUBE_IP/$(minikube ip)/g" srcs/ftps/setssl.sh

docker build -t ftps srcs/ftps/

cp srcs/originals/telegraf.yaml srcs/telegraf.yaml
sed -i '' "s/MINIKUBE_IP/$(minikube ip)/g" srcs/telegraf.yaml

docker build -t telegraf srcs/telegraf/
docker build -t influxdb srcs/influxdb/
docker build -t phpmyadmin srcs/phpmyadmin/
docker build -t grafana srcs/grafana

kubectl apply -f ./srcs/

# ******************************* import .sql ******************************** #

echo "${green}Importing SQL db...${cend}"
while [[ $(kubectl get pods -l app=mysql -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do
	sleep 5;
done

sleep 30

kubectl exec -i $(kubectl get pods | grep mysql | cut -d" " -f1) -- mysql wordpressdb -u root < srcs/mysql/wordpressdb.sql

# ***************************** import influxdb ****************************** #

mkdir -p ./srcs/dashboards
echo "${green}Importing dashboards...${cend}"
cp srcs/originals/setdbs.sh srcs/dashboards/setdbs.sh
sed -i '' "s/MINIKUBE_IP/$(minikube ip)/g" srcs/dashboards/setdbs.sh

while [[ $(kubectl get pods -l app=grafana -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do
	sleep 5;
done

sleep 30

sh srcs/dashboards/setdbs.sh

# test ssh : ssh admin@$(minikube ip) -p 400
# kill container : kubectl exec -it $(kubectl get pods | grep SERVICE_NAME | cut -d" " -f1) -- /bin/sh -c "kill 1"
# clean : minikube delete && rm ./srcs/dashboards/* && rm ./srcs/mysql/wordpressdb.sql && rm ./srcs/telegraf.yaml && rm ./srcs/ftps/setssl.sh && rm ./srcs/nginx/index.html
