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

tls-configuration:
  file.managed:
    - name: /etc/default/docker
    - template: jinja
    - source: salt://docker/files/tls-defaults.conf
    - watch_in:
      - service: docker
