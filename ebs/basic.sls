master-ep0-format:
  cmd.run:
    - name : mkfs -t ext4 /dev/xvdb

master-ep1-format:
  cmd.run:
    - name : mkfs -t ext4 /dev/xvdc

master-ep0-mount:
  mount.mounted:
    - name:  /mnt/ep0
    - device: /dev/xvdb
    - fstype: ext4
    - mkmnt: True
    - opts:
      - defaults

master-ep1-mount:
  mount.mounted:
    - name:  /mnt/ep1
    - device: /dev/xvdc
    - fstype: ext4
    - mkmnt: True
    - opts:
      - defaults

