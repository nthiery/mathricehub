# Shared notes and files for deploying a Jupyterhub+Sage on Mathrice

Ubuntu 16.4, 4Gb, 2 cpus

ssh mathricehub

ssh root@jupyterhub

root@ubuntu:~# ls
root@ubuntu:~# df -h
Filesystem      Size  Used Avail Use% Mounted on
udev            1.9G     0  1.9G   0% /dev
...
/dev/vdb         49G   33M   49G   1% /mnt/vdb      # persistent directory

# Base stuff: Python / nodejs / ...

# References: https://www.digitalocean.com/community/tutorials/how-to-install-node-js-on-ubuntu-16-04

apt update
apt install python3-pip
apt install nodejs npm
apt install nodejs-legacy # maybe; yes in fact :-)

apt install locales-all    # to avoid locale complaints

pip3 install --upgrade pip setuptools
pip3 install jupyterhub notebook
npm install -g configurable-http-proxy

# Test

jupyterhub

# now we can connect with any local UNIX account

mkdir /mnt/vdb/mathricehub/
cd /mnt/vdb/mathricehub/
jupyterhub --generate-config

# https://jupyterhub-tutorial.readthedocs.io/en/latest/

# Setup SSL (self-signed certificate for now)

openssl req -x509 -nodes -days 365 -newkey rsa:1024 -keyout mykey.key -out mycert.pem
# Specify 157.136.240.21:8080 as IP address

# Setup OAuth authentication

< edit config file ... >
pip3 install oauthenticator

# First experiment: setup OAuth authentication with github
# Ref: https://github.com/jupyterhub/oauthenticator

# Let's go for mathrice OAuth
# Create an authenticator class in mathrice.py, inspired from the github authenticator class
# Reference: mathrice OAuth https://plm.wiki.math.cnrs.fr/servicesnumeriques/identites/oauth2



# Install Sage

wget www-ftp.lip6.fr/pub/math/sagemath/linux/64bit/sage-7.3-Ubuntu_16.04-x86_64.tar.bz2


# Install Sage kernel in host Jupyter
