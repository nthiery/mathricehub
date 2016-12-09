# Shared notes and files for deploying a Jupyterhub+Sage on Mathrice

## Host configuration

Ubuntu 16.4, 4Gb, 2 cpus

Log on the entry-point machine:

    ssh mathricehub

Log on the future jupyterhub host:

    ssh root@jupyterhub

Check the persistent directory

    root@ubuntu:~# ls
    root@ubuntu:~# df -h
    Filesystem      Size  Used Avail Use% Mounted on
    ...
    /dev/vdb         49G   33M   49G   1% /mnt/vdb

## Install Base stuff: Python / nodejs / ...

References: https://www.digitalocean.com/community/tutorials/how-to-install-node-js-on-ubuntu-16-04

    apt update
    apt install python3-pip
    apt install nodejs npm
    apt install nodejs-legacy # maybe; yes in fact :-)

    apt install locales-all    # to avoid locale complaints

    pip3 install --upgrade pip setuptools
    pip3 install jupyterhub notebook
    npm install -g configurable-http-proxy

## Test: now we can connect with any local UNIX account

    jupyterhub

## Start tweaking the configuration

Reference: https://jupyterhub-tutorial.readthedocs.io/

    mkdir /mnt/vdb/mathricehub/
    cd /mnt/vdb/mathricehub/
    jupyterhub --generate-config

## Setup SSL (self-signed certificate for now)

    openssl req -x509 -nodes -days 365 -newkey rsa:1024 -keyout mykey.key -out mycert.pem
    # Specify 157.136.240.21:8080 as IP address

## Setup OAuth authentication

    < edit config file ... >
    pip3 install oauthenticator

### First experiment: setup OAuth with github

Reference: https://github.com/jupyterhub/oauthenticator

### Second experiment: setup OAuth with mathrice

Create an authenticator class in mathrice.py, inspired from the github authenticator class

Reference: mathrice OAuth https://plm.wiki.math.cnrs.fr/servicesnumeriques/identites/oauth2



## Install Sage

    wget www-ftp.lip6.fr/pub/math/sagemath/linux/64bit/sage-7.3-Ubuntu_16.04-x86_64.tar.bz2
    tar xf sage-7.3-Ubuntu_16.04-x86_64.tar.bz2
    SageMath/sage


Install Sage kernel in host Jupyter


