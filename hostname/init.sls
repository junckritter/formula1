{% set fqdn = grains['id'] %}

host-entry:
  host.present:
    - ip: 127.0.0.1
    - names:
      - {{ fqdn }}

/etc/hostname:
  file.managed:
    - contents: {{ fqdn }}
    - backup: false

set-fqdn:
  cmd.run:
    - name: hostname {{ fqdn }}
    - unless: test "{{ fqdn }}" == "$(hostname)"
