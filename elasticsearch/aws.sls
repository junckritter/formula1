include:
  - elasticsearch

elasticsearch-aws-plugin:
  cmd.run:
    - name: bin/plugin -install elasticsearch/elasticsearch-cloud-aws/2.3.0
    - cwd: /usr/share/elasticsearch
    - unless: stat /usr/share/elasticsearch/plugins/cloud-aws
    - watch_in:
      - service: elasticsearch
