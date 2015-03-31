/etc/init/mounted-var-lib.conf:
  file.managed:
    - source: salt://ebs/files/upstart-instance-var

master-data-format:
  cmd.run:
    - name : mkfs -t ext4 /dev/xvdf

master-mnt-format:
  cmd.run:
    - name : mkfs -t ext4 /dev/xvdb

master-mnt-mount:
  mount.mounted:
    - name:  /mnt
    - device: /dev/xvdb
    - fstype: ext4
    - mkmnt: True
    - opts:
      - defaults

master-data-mount:
  mount.mounted:
    - name:  /data
    - device: /dev/xvdf
    - fstype: ext4
    - mkmnt: True
    - opts:
      - defaults

emit-mount-data:
  cmd.run:
    - name: initctl emit mounted MOUNTPOINT=/mnt
