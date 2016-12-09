# == Class: sage8_lyon::packages
#
# Cette classe installe les packages necessaire pour le bon
# fonctionnement de ce que fait sage8_lyon
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

class sage8_lyon::packages {
# Ouverture des filtres IPtables pour les installations
  Package {
    before => Class['plm_fw::closetemp'],
    require => Class['plm_fw::opentemp'],
  }
# Paquets de la distribution Ubuntu
  package{ ['python3-pip','npm','nodejs-legacy','build-essential','python3-dev','libuser']:
    ensure => 'installed',
    provider => 'apt',
  }
# ajouter pour Ubuntu16.04 : locales-all

# Paquets pip3
# le provider est disponible dans puppet4
#   package { ['pip', 'setuptools', 'jupyterhub', 'notebook', 'sudospawner', 'bs4', 'oauthenticator', ]:
#     ensure => 'latest',
#     provider => 'pip3',
#   }

  exec { 'pip3 setuptools':
    command => 'pip3 install --upgrade setuptools',
    before => Class['plm_fw::closetemp'],
    require => Class['plm_fw::opentemp'],
  }
  exec { 'pip3 notebook':
    command => 'pip3 install --upgrade notebook',
    before => Class['plm_fw::closetemp'],
    require => Class['plm_fw::opentemp'],
  }
  exec { 'pip3 jupyter':
    command => 'pip3 install jupyter',
    creates => '/usr/local/bin/jupyter',
    before => Class['plm_fw::closetemp'],
    require => Class['plm_fw::opentemp'],
  }
  exec { 'pip3 jupyterhub':
    command => 'pip3 install jupyterhub',
    creates => '/usr/local/bin/jupyterhub',
    before => Class['plm_fw::closetemp'],
    require => Class['plm_fw::opentemp'],
  }
  exec { 'pip3 sudospawner':
    # command => 'pip3 install git+https://github.com/prodiguer/sudospawner',
    command => 'pip3 install sudospawner',
    creates => '/usr/local/bin/sudospawner',
    before => Class['plm_fw::closetemp'],
    require => Class['plm_fw::opentemp'],
  }
  exec { 'pip3 bs4':
    command => 'pip3 install bs4',
    creates => '/usr/local/lib/python3.4/dist-packages/bs4',
    before => Class['plm_fw::closetemp'],
    require => Class['plm_fw::opentemp'],
  }
  exec { 'pip3 oauthenticator':
    command => 'pip3 install oauthenticator',
    creates => '/usr/local/lib/python3.4/dist-packages/oauthenticator',
    before => Class['plm_fw::closetemp'],
    require => Class['plm_fw::opentemp'],
  }

# Paquets npm
  exec { 'npm install -g configurable-http-proxy':
    creates => '/usr/local/bin/configurable-http-proxy',
    before => Class['plm_fw::closetemp'],
    require => Class['plm_fw::opentemp'],
  }
}
