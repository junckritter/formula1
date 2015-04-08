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

ca-present:
  file.managed:
    - name: /root/docker/ca.pem
    - makedirs: True
    - source: {{ conf.get('ca_path') }}
    - watch_in:
      - service: docker

server-cert-present:
  file.managed:
    - name: /root/docker/server-cert.pem
    - makedirs: True
    - source: {{ conf.get('server_cert_path') }}
    - watch_in:
      - service: docker

server-key-present:
  file.managed:
    - name: /root/docker/server-key.pem
    - makedirs: True
    - source: {{ conf.get('server_key_path') }}
    - watch_in:
      - service: docker

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
    - hash: md5=ffe65db6936071fa14e2130a1e58e803
    - watch_in:
      - service: docker

allow-docker-in-firewall:
  cmd.run:
    - name: ufw allow to any port 2375
