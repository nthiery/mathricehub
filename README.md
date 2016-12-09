# Shared notes and files for deploying a Jupyterhub+Sage on Mathrice

## [2016-12-07 Sprint: JupyterHub and Mathrice's OAuth2 authentication](2016-12-07-Orsay-OAuth-Sprint.md)

## 2016-12-09 Sprint: Puppetization

Laurent, Nicolas, Thierry

Updated [Puppet 3 script](TODO: Laurent, put link here) from a
previous sprint between Laurent and Thierry with the instructions from
12/07. Works on the sage8 host all the way up to the OAuth failure of
12/07.

## Next steps

- [ ] Convert the Puppet 3 scripts to Puppet 4
- [ ] Fix the OAuth failure (?)
- [ ] White listing of only people from the math community
- [ ] Run the Jupyter servers in docker containers on the localhost (DockerSpawner)
- [ ] Run the Jupyter servers in rocket containers on the localhost (RocketSpawner to be implemented)
- [ ] Run the Jupyter servers in containers, with load balancing
- [ ] File sharing with infinity
