{% set config_path = salt['pillar.get']('redis:config_path', '/etc/redis/redis.conf') %}

{{ config_path }}:
  file.managed:
    - source: salt://redis/files/redis.conf.jinja
    - template: jinja
    - mode: 644
    - makedirs: True

redis-server:
  pkgrepo.managed:
    - humanname: Redis rwky PPA
    - ppa: rwky/redis

  pkg.installed:
    - require:
      - pkgrepo: redis-server

  service.running:
    - watch:
      - file: {{ config_path }}
    - require:
      - pkg: redis-server
