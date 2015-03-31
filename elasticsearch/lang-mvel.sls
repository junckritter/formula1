include:
  - elasticsearch

elasticsearch-lang-mvel-plugin:
  cmd.run:
    - name: bin/plugin -install elasticsearch/elasticsearch-lang-mvel/1.4.1
    - cwd: /usr/share/elasticsearch
    - unless: stat /usr/share/elasticsearch/plugins/lang-mvel
    - watch_in:
      - service: elasticsearch
