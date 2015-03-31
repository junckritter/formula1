{% set data_dir = salt['pillar.get']('elasticsearch:data_dir') %}
{% set log_dir = salt['pillar.get']('elasticsearch:log_dir') %}

include:
  - java
  - pam-limits

elasticsearch-repo:
  pkgrepo.managed:
      - name: deb http://packages.elasticsearch.org/elasticsearch/{{ salt['pillar.get']('elasticsearch:version') }}/debian stable main
      - key_url: http://packages.elasticsearch.org/GPG-KEY-elasticsearch

elasticsearch-safe-config:
  file.managed:
    - name: /etc/elasticsearch/elasticsearch.yml
    - source: salt://elasticsearch/files/safe-configuration.yml
    - template: jinja
    - require:
      - pkg: elasticsearch
    - watch_in:
      - service: elasticsearch

elasticsearch-default-environment-config:
  file.managed:
    - name: /etc/default/elasticsearch
    - source: salt://elasticsearch/files/etc-config
    - template: jinja
    - require:
      - pkg: elasticsearch
    - watch_in:
      - service: elasticsearch

{% if data_dir != '' %}
{{ data_dir }}:
    file.directory:
    - user: elasticsearch
    - group: elasticsearch
    - dir_mode: 755
{% endif %}

{% if log_dir != '' %}
{{ log_dir }}:
    file.directory:
    - user: elasticsearch
    - group: elasticsearch
    - dir_mode: 755
{% endif %}

elasticsearch-security-limits:
  file.append:
    - name: /etc/security/limits.conf
    - text:
      - elasticsearch soft nofile 65535
      - elasticsearch hard nofile 65535
      - elasticsearch soft memlock unlimited
      - elasticsearch hard memlock unlimited
    - require:
      - sls: pam-limits

elasticsearch:
  pkg:
    - installed
    - require:
      - pkgrepo: elasticsearch-repo
      - sls: java

  service:
    - running
    - enable: True
    - require:
       - file: elasticsearch-security-limits
    - watch:
      - pkg: elasticsearch

