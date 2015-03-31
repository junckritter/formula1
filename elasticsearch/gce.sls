include:
  - elasticsearch

elasticsearch-gce-plugin:
  cmd.run:
    - name: bin/plugin -install elasticsearch/elasticsearch-cloud-gce/2.3.0
    - cwd: /usr/share/elasticsearch
    - unless: stat /usr/share/elasticsearch/plugins/cloud-gce
    - watch_in:
      - service: elasticsearch
