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
      - key_url: salt://docker/docker.pgp
      - require_in:
          - pkg: lxc-docker
      - require:
        - pkg: docker-python-apt

lxc-docker:
  pkg.latest:
    - require:
      - pkg: docker-dependencies

ca-present:
  file.managed:
    - name: /root/docker/ca.pem
    - makedirs: True
    - source: {{ conf.get('ca_path') }}

server-cert-present:
  file.managed:
    - name: /root/docker/server-cert.pem
    - makedirs: True
    - source: {{ conf.get('server_cert_path') }}

server-key-present:
  file.managed:
    - name: /root/docker/server-key.pem
    - makedirs: True
    - source: {{ conf.get('server_key_path') }}

docker-configuration:
  file.managed:
    - name: /etc/default/docker
    - template: jinja
    - source: salt://docker/files/defaults.conf
    - watch_in:
      service: docker

docker-service:
  service.running:
    - name: docker
    - enable:

allow-docker-in-firewall:
  cmd.run:
    - name: ufw allow to any port 2375
