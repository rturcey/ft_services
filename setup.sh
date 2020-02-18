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

# **************************** variables settings **************************** #

WH_VAR=0

if [ -z "$USER" ]; then
	export USER=$(whoami)
fi

mkdir -p /goinfre/$USER

# ****************************** checking brew ******************************* #

WH_VAR=$(which -s brew)

if [ WH_VAR = 1 ]; then
	rm -rf $HOME/.brew
	git clone --depth=1 https://github.com/Homebrew/brew $HOME/.brew
	echo 'export PATH=$HOME/.brew/bin:$PATH' >> $HOME/.zshrc
	source $HOME/.zshrc
fi

brew update

# ***************************** checking minikube **************************** #

WH_VAR=$(which -s minikube)

if [ WH_VAR = 1 ]; then
	brew install minikube
fi

MINIKUBE_HOME=/goinfre/$USER
export MINIKUBE_HOME

# ***************************** checking kubectl ***************************** #

WH_VAR=$(which -s kubectl)

if [ WH_VAR = 1 ]; then
	brew install kubectl
fi

# ******************************* get started ******************************** #

minikube config set vm-driver virtualbox
minikube delete
minikube start --extra-config=apiserver.service-node-port-range=1-30000
eval $(minikube docker-env)

minikube addons enable ingress
minikube addons enable dashboard

docker build -t nginx srcs/nginx/
docker build -t mysql srcs/mysql/
docker build -t wordpress srcs/wordpress/

kubectl apply -f ./srcs/

MINIKUBE_IP=$(minikube ip)
export MINIKUBE_IP
echo $MINIKUBE_IP
#kubectl delete -k ./
