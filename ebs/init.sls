/etc/init/mounted-mnt.conf:
  file.managed:
    - source: salt://ebs/files/upstart-tmp

/etc/init/mounted-var-lib.conf:
  file.managed:
    - source: salt://ebs/files/upstart-var-lib

ephemeral1:
  mount.mounted:
    - name: /media
    - device: /dev/xvdc
    - fstype: ext4
    - opts:
      - defaults

master-data-format:
  cmd.run:
    - name : mkfs -t ext4 /dev/xvdf

master-data-mount:
  mount.mounted:
    - name:  /data
    - device: /dev/xvdf
    - fstype: ext4
    - mkmnt: True
    - opts:
      - defaults

emit-mount-tmp:
  cmd.run:
    - name: initctl emit mounted MOUNTPOINT=/mnt

emit-mount-data:
  cmd.run:
    - name: initctl emit mounted MOUNTPOINT=/data
