{% set conf = pillar.get('docker') %}

docker-python-apt:
  pkg.installed:
    - name: python-apt

docker-dependencies:
   pkg.installed:
    - pkgs:
      - iptables
      - ca-certificates
      - lxc

docker-repo:
    pkgrepo.managed:
      - repo: 'deb http://get.docker.io/ubuntu docker main'
      - file: '/etc/apt/sources.list.d/docker.list'
      - key_url: salt://docker/files/docker.gpg
      - require_in:
          - pkg: lxc-docker
      - require:
        - pkg: docker-python-apt

lxc-docker:
  pkg.latest:
    - require:
      - pkg: docker-dependencies

docker-service:
  service.running:
    - name: docker
    - enable: True

docker-configuration:
  file.managed:
    - name: /etc/default/docker
    - template: jinja
    - source: salt://docker/files/defaults.conf
    - watch_in:
      - service: docker

docker-memory-ulimit:
  file.patch:
    - name: /etc/init/docker.conf
    - source: salt://docker/files/conf.patch
    - hash: md5=0f960d8d796de6195e9c0e1d633945fb
    - watch_in:
      - service: docker
