include:
  - elasticsearch.aws

curl:
  pkg.installed:
    - name: curl

elasticsearch-s3-definition:
  cmd.script:
    - source: salt://elasticsearch/files/s3.sh.jinja
    - template: jinja
    - user: elasticsearch
    - require:
      - pkg: curl

/bin/sh -l -c 'curl -XPUT "http://localhost:9200/_snapshot/s3_backups/snapshot_`date +\%Y-\%m-\%d`?wait_for_completion=true"':
  cron.present:
    - identifier: daily_elastic_backup
    - user: root
    - hour: 5
    - minute: 0

