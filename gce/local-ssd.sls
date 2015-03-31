{% set mount =  salt['pillar.get']('gce:mount-local-ssd', '/mnt/ssd0') %}

local-ssd:
  file.directory:
    - name: {{ mount }}
    - dir_mode: 777

mount-local-ssd:
  cmd.run:
    - name : /usr/share/google/safe_format_and_mount -m "mkfs.ext4 -F" /dev/disk/by-id/google-local-ssd-0 {{ mount }}
