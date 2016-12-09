# == Class: sage8_lyon::jupyterhub
#
# Cette classe installe JupyterHub
#
# === Parameters
#
# La liste des parametres qu'utilise la classe
#
# [*parametre1*]
#   description pour chaque parametre.
#
# === Variables
#
# La liste des variables
#
# [*variable*]
#   description pour chaque variable
#
# === Examples
#
# Un exemple d'usage
#
# === Authors
#
# plm-team < plm-team@listes.mathrice.fr >
#
# === Copyright
#
#           DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                   Version 2, December 2004
#
#Copyright (C) 2004 Sam Hocevar <sam@hocevar.net>
#
#Everyone is permitted to copy and distribute verbatim or modified
#copies of this license document, and changing it is allowed as long
#as the name is changed.
#
#           DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#  TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
# 0. You just DO WHAT THE FUCK YOU WANT TO.

class sage8_lyon::jupyterhub {


  file { '/usr/local/home':
    ensure => 'directory',
    owner => 'root',
    group => 'root',
    mode => '0755',
  }
  user {'jupyterhub':
    ensure => 'present',
    comment => 'Jupyterhub user',
    expiry => 'absent',
    home => '/usr/local/home/jupyterhub',
    managehome => true,
    provider => 'useradd',
    shell => '/bin/bash',
    groups => [ 'ssl-cert', 'shadow', ],
    require => File['/usr/local/home'],
  }
  user {'user0':
    ensure => 'present',
    comment => 'user test',
    expiry => 'absent',
    home => '/usr/local/home/user0',
    managehome => true,
    password =>  '$6$yjls5HdtGn$V9ZVTaKasATpzGUoaewy9FMAvfDKUdalwwrg607D3ecpkD.oNRW2XoaLqUI37pmsg6vpQE1r1Lk8AJ8.KE4ON1',
    provider => 'useradd',
    shell => '/bin/bash',
    # groups => [ 'jupyterhub', ],
    require => File['/usr/local/home'],
  }
# Creation des repertoires conf, log et data
  file {'/etc/jupyterhub':
    ensure => 'directory',
    owner => 'jupyterhub',
    group => 'jupyterhub',
    mode => '0755',
    require => User['jupyterhub'],
  }
  file {'/var/log/jupyterhub':
    ensure => 'directory',
    owner => 'jupyterhub',
    group => 'jupyterhub',
    mode => '0755',
  }
  file {'/var/lib/jupyterhub':
    ensure => 'directory',
    owner => 'jupyterhub',
    group => 'jupyterhub',
    mode => '0755',
  }

# Fichier de configuration /etc/jupyterhub/jupyterhub_config.py
# creation du fichier par defaut
  exec {'jupyterhub generate-config':
    command => '/usr/local/bin/jupyterhub --generate-config -f /etc/jupyterhub/jupyterhub_config.py',
    creates => '/etc/jupyterhub/jupyterhub_config.py',
    user => 'root',
    require => [ Exec['pip3 jupyterhub'], File['/etc/jupyterhub', '/var/log/jupyterhub', '/var/lib/jupyterhub'], ],
  }
# modification de parametres
  file_line {'jupyterhub_config.py JupyterHub.port':
    path => '/etc/jupyterhub/jupyterhub_config.py',
    match => 'c.JupyterHub.port = ',
    line => 'c.JupyterHub.port = 443',
    require => Exec['jupyterhub generate-config'],
  }
  file_line {'jupyterhub_config.py JupyterHub.ssl_cert':
    path => '/etc/jupyterhub/jupyterhub_config.py',
    match => 'c.JupyterHub.ssl_cert = ',
    line => 'c.JupyterHub.ssl_cert = \'/etc/ssl/certs/jupyter-test.math.cnrs.fr.crt\'',
    require => Exec['jupyterhub generate-config'],
  }
  file_line {'jupyterhub_config.py JupyterHub.ssl_key':
    path => '/etc/jupyterhub/jupyterhub_config.py',
    match => 'c.JupyterHub.ssl_key = ',
    line => 'c.JupyterHub.ssl_key = \'/etc/ssl/private/jupyter-test.math.cnrs.fr.key\'',
    require => Exec['jupyterhub generate-config'],
  }
  file_line {'jupyterhub_config.py JupyterHub.pid_file':
    path => '/etc/jupyterhub/jupyterhub_config.py',
    match => 'c.JupyterHub.pid_file = ',
    line => 'c.JupyterHub.pid_file = \'/var/lib/jupyterhub/jupyterhub.pid\'',
    require => Exec['jupyterhub generate-config'],
  }
  file_line {'jupyterhub_config.py JupyterHub.cookie_secret_file':
    path => '/etc/jupyterhub/jupyterhub_config.py',
    match => 'c.JupyterHub.cookie_secret_file = ',
    line => 'c.JupyterHub.cookie_secret_file = \'/var/lib/jupyterhub/jupyterhub_cookie_secret\'',
    require => Exec['jupyterhub generate-config'],
  }
  file_line {'jupyterhub_config.py JupyterHub.db_url':
    path => '/etc/jupyterhub/jupyterhub_config.py',
    match => 'c.JupyterHub.db_url = ',
    line => 'c.JupyterHub.db_url = \'sqlite:////var/lib/jupyterhub/jupyterhub.sqlite\'',
    require => Exec['jupyterhub generate-config'],
  }
  file_line {'jupyterhub_config.py JupyterHub.extra_log_file':
    path => '/etc/jupyterhub/jupyterhub_config.py',
    match => 'c.JupyterHub.extra_log_file = ',
    line => 'c.JupyterHub.extra_log_file = \'/var/log/jupyterhub/jupyterhub.log\'',
    require => Exec['jupyterhub generate-config'],
  }
  file_line {'jupyterhub_config.py JupyterHub.spawner_class':
    path => '/etc/jupyterhub/jupyterhub_config.py',
    match => 'c.JupyterHub.spawner_class = ',
    line => 'c.JupyterHub.spawner_class = \'sudospawner.SudoSpawner\'',
    require => Exec['jupyterhub generate-config'],
  }
  file_line {'jupyterhub_config.py JupyterHub.authenticator_class':
    path => '/etc/jupyterhub/jupyterhub_config.py',
    match => 'c.JupyterHub.authenticator_class = ',
    line => 'c.JupyterHub.authenticator_class = LocalMathriceOAuthenticator',
    require => Exec['jupyterhub generate-config'],
  }
# importation de classes
  file_line {'jupyterhub_config.py import sys os':
    path => '/etc/jupyterhub/jupyterhub_config.py',
    after => '# Configuration file for jupyterhub.',
    line => 'import sys,os',
    require => Exec['jupyterhub generate-config'],
  }
  file_line {'jupyterhub_config.py importLocalMathriceOAuthenticator':
    path => '/etc/jupyterhub/jupyterhub_config.py',
    after => 'import sys',
    match => 'import LocalMathriceOAuthenticator',
    line => 'sys.path.insert(0,"/etc/jupyterhub");from mathrice import LocalMathriceOAuthenticator',
    require => [ Exec['jupyterhub generate-config'], File_line['jupyterhub_config.py import sys os'] ],
  }
# ajout des parametres LocalMathriceOAuthenticator
  exec { 'jupyterhub_config.py oAuthMathrice':
    command => 'echo "
c.LocalMathriceOAuthenticator.create_system_users=True
c.LocalMathriceOAuthenticator.client_id=os.environ[\"OAUTH_CLIENT_ID\"]
c.LocalMathriceOAuthenticator.client_secret=os.environ[\"OAUTH_CLIENT_SECRET\"]
c.MathriceOAuthenticator.oauth_callback_url = os.environ[\"OAUTH_CALLBACK_URL\"]
">>/etc/jupyterhub/jupyterhub_config.py',
    unless => 'grep "c.LocalMathriceOAuthenticator.create_system_users" /etc/jupyterhub/jupyterhub_config.py',
   require => Exec['jupyterhub generate-config'],
  }

# Classe d'authentification oAuth sur la PLM
  file {'/etc/jupyterhub/mathrice.py':
    source => 'puppet:///modules/sage8_lyon/mathrice.py',
    owner => 'root',
    group => 'root',
    mode => '0644',
  }
# Les certificats du service HTTPs
  file {'/etc/ssl/certs/jupyter-test.math.cnrs.fr.crt':
    source => 'puppet:///private/jupyter-test.math.cnrs.fr.crt',
    owner => 'root',
    group => 'root',
    mode => '0644',
  }
  file {'/etc/ssl/private/jupyter-test.math.cnrs.fr.key':
    source => 'puppet:///private/jupyter-test.math.cnrs.fr.key',
    owner => 'root',
    group => 'ssl-cert',
    mode => '0640',
  }
# Autoriser lancement sudospawner par jupyterhub sous identite utilisateur
  file {'/etc/sudoers.d/jupyterhub':
    source => 'puppet:///modules/sage8_lyon/sudoers.d/jupyterhub',
    owner => 'root',
    group => 'root',
    mode => '0440',
  }
# Autoriser l_ouverture du port TCP/443 sans etre root
  exec {'setcap \'cap_net_bind_service=+ep\' /usr/bin/nodejs':
    command => 'setcap \'cap_net_bind_service=+ep\' /usr/bin/nodejs',
    unless => 'getcap /usr/bin/nodejs|grep -qs \'cap_net_bind_service+ep\'',
    user => 'root',
    require => Package[ 'nodejs-legacy' ],
  }

#
#  file { '/etc/jupyterhub/start_restart_jupyterhub':
#    source => 'puppet:///modules/sage8_lyon/start_restart_jupyterhub',
#    owner => 'root',
#    group => 'root',
#    mode => '0755',
#    require => File['/etc/jupyterhub'],
#  }
#
#  file_line {'rclocal_jupyterhub':
#    path => '/etc/rc.local',
#    line => '/etc/jupyterhub/start_restart_jupyterhub',
#    require => File['/etc/jupyterhub/start_restart_jupyterhub'],
#  }
#
#
##jupyterhub --ip 10.0.1.2 --port 443 --ssl-key my_ssl.key --ssl-cert my_ssl.cert
#
## Mini site web d'accueil sur TCP/80
## utilise Flask et Tornado installés dans le python de SageMath
#  file {'/home/sage/Flask':
#    ensure => 'directory',
#    recurse => true,
#    purge => true,
#    owner => 'sage',
#    group => 'sage',
#    source => 'puppet:///modules/sage8_lyon/Flask',
#    require => User['sage'],
#  }
#
#  file_line {'rclocal_flask':
#    path => '/etc/rc.local',
#    line => '(cd /home/sage/Flask; sudo -u sage sage -python serv.py &)',
#    require => File['/home/sage/Flask'],
#  }
  # $sage_archivefilename = hiera('sage_archivefilename')
  # $sage_archivesite = hiera('sage_archivesite')
  # $sage_packages = hiera_array('sage_packages')

  # user { 'sage':
  #   ensure => 'present',
  #   comment => 'SageMath user',
  #   expiry => 'absent',
  #   home => '/home/sage',
  #   managehome => true,
  #   provider => 'useradd',
  #   shell => '/bin/bash',
  # }

   # exec { 'download SageMath':
#    command => "rm -f /home/sage/sage-*.tar.bz2; rm -rf /home/sage/SageMath; rm -rf /home/sage/.sage; wget --timeout=30 ${sage_archivesite}${sage_archivefilename}",
#    creates => "/home/sage/${sage_archivefilename}",
#    user => 'sage',
#    cwd => '/home/sage',
#    timeout => '600',
#    before  => Class['plm_fw::closetemp'],
#    require => [ Class['plm_fw::opentemp'], User['sage'], ],
#  }

#  exec { 'untar SageMath':
#    command => 'tar -jxf sage-7.3-Ubuntu_14.04-x86_64.tar.bz2',
#    creates => '/home/sage/SageMath',
#    user => 'sage',
#    cwd => '/home/sage',
#    timeout => '0',
#    require => Exec['download SageMath'],
#  }
#
#  exec { 'install SageMath':
#    command => 'echo -n "SageMath new install">> install.log; date >> install.log;/home/sage/SageMath/sage >> install.log',
#    creates => '/home/sage/.sage',
#    user => 'sage',
#    cwd => '/home/sage/SageMath',
#    environment => 'HOME=/home/sage',
#    timeout => '0',
#    require => Exec['untar SageMath'],
#  }
#
#  define install_sage_package() {
#    exec { "package sage $name":
#      command => "/home/sage/SageMath/sage -i $name >> install.log",
#      onlyif  => "/home/sage/SageMath/sage -optional|grep '^$name.* (not_installed)$'",
#      cwd   => '/home/sage/SageMath',
#      user   => 'sage',
#      environment => 'HOME=/home/sage',
#      timeout => '0',
#      before  => Class['plm_fw::closetemp'],
#      require => [ Class['plm_fw::opentemp'], Exec['install SageMath'], Package['build-essential', 'gfortran'], ],
#    }
#  }
#
#  install_sage_package{ $sage_packages: }
#
#  file {'/opt/anaconda/share/jupyter/kernels/sage':
#    ensure => 'directory',
#    recurse => true,
#    purge => true,
#    source => 'puppet:///modules/sage8_lyon/jupyter_kernels_sage',
#    require => Conda::Package['jupyterhub'],
#  }
}
