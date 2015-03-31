s3cmd-repo:
  pkgrepo.managed:
      - name: deb http://s3tools.org/repo/deb-all stable/
      - key_url: http://s3tools.org/repo/deb-all/stable/s3tools.key

s3cmd:
  pkg:
    - installed
    - require:
      - pkgrepo: s3cmd-repo

/root/.s3cfg:
  file.managed:
    - source: salt://redis/files/s3cfg.jinja
    - template: jinja

/bin/sh -l -c 's3cmd put "/var/lib/redis/redis.rdb" "s3://{{ pillar['redis_backup']['s3_bucket'] }}/redis-`date +\%Y-\%m-\%d`.rdb"':
  cron.present:
    - identifier: daily_redis_backup
    - user: root
    - hour: 5
    - minute: 0
