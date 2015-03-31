# https://gist.github.com/renoirb/6722890

oracle-ppa:
  pkgrepo.managed:
    - humanname: WebUpd8 Oracle Java PPA repository
    - ppa: webupd8team/java

oracle-java-license-autoaccept:
  debconf.set:
    - name: oracle-java8-installer
    - data:
        'shared/accepted-oracle-license-v1-1': {'type': 'boolean', 'value': True}

oracle-java8-installer:
  pkg:
    - installed
    - require:
      - pkgrepo: oracle-ppa
