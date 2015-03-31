include:
  - postgres.client
  - postgres.server

wal-e_user:
  user.present:
    - name: wal-e
    - groups:
      - apps
      - postgres
    - shell: /bin/bash

wal-e:
  virtualenv.managed:
    - name: /home/wal-e/wal-e
    - system_site_packages: False
    - requirements: salt://postgres/files/requirements.txt
    - require:
      - pkg: wal-e-deps
  file.directory:
    - name: /etc/wal-e.d/env
    - user: root
    - group: postgres
    - mode: 750
    - makedirs: True
    - recurse:
      - user
      - group

/home/wal-e/wal-e:
  file.directory:
    - user: wal-e
    - group: postgres
    - recurse:
      - user
      - group
      - mode

wal-e-deps:
  pkg.installed:
    - names:
      - python-dev
      - python-virtualenv
      - daemontools
      - lzop
      - pv

/etc/postgresql/9.3/main/postgresql.conf:
  file.append:
    - text:
      - wal_level = archive
      - archive_mode = on
      - archive_command = 'envdir /etc/wal-e.d/env /home/wal-e/wal-e/bin/wal-e wal-push %p'
      - archive_timeout = 60
    - watch_in:
      - service: postgresql

wal-e-aws-secret-key:
  file.managed:
    - name: /etc/wal-e.d/env/AWS_SECRET_ACCESS_KEY
    - contents: {{ pillar['aws']['secret_key'] }}
    - mode: 640
    - require:
      - file: wal-e

wal-e-aws-access-key:
  file.managed:
    - name: /etc/wal-e.d/env/AWS_ACCESS_KEY_ID
    - contents: {{ pillar['aws']['access_key'] }}
    - mode: 640
    - require:
      - file: wal-e

wal-e-wale-prefix:
  file.managed:
    - name: /etc/wal-e.d/env/WALE_S3_PREFIX
    - contents: s3://{{ pillar['postgres_backup']['s3_bucket'] }}
    - mode: 640
    - require:
      - file: wal-e

envdir /etc/wal-e.d/env /home/wal-e/wal-e/bin/wal-e backup-push /var/lib/postgresql/9.3/main/:
  cron.present:
    - identifier: daily_wal-e_backup
    - user: postgres
    - hour: 5
    - minute: 0
