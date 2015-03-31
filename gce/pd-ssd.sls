{% set id =  salt['pillar.get']('gce:id-persistent-ssd', fqdn) %}
{% set mount =  salt['pillar.get']('gce:mount-persistent-ssd', '/mnt/pdssd0') %}

pd-ssd:
  file.directory:
    - name: {{ mount }}
    - device: /dev/disk/by-id/google-{{ id }}

mount-local-ssd:
  cmd.run:
    - name : /usr/share/google/safe_format_and_mount -m "mkfs.ext4 -F" /dev/disk/by-id/google-{{ id }} /mnt/pdssd0
