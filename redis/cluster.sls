{% set conf = pillar.get('redis-cluster') %}

redis:
  user.present:
    - shell: /bin/false
  group.present:
    - addusers:
      - redis

build-essential:
  pkg:
    - installed

redis-sources-present:
  cmd.script:
    - cwd: /tmp
    - source: salt://redis/files/download_cluster.sh.jinja
    - context:
      version: {{ conf.get('version') }}
    - template: jinja
    - unless: stat {{ conf.get('version') }}

/usr/local/bin/redis-cluster-server:
  file.copy:
    - source: /tmp/redis-{{ conf.get('version') }}/src/redis-server
    - user: root
    - group: root

{% for port in conf.get('ports') %}

{{ conf.get('dir') }}{{ port }}/redis.conf:
  file.managed:
    - source: salt://redis/files/redis-cluster.conf.jinja
    - template: jinja
    - context:
      port: {{ port }}
      dir: {{ conf.get('dir') }}{{ port }}
    - makedirs: True

/etc/init/redis-cluster-{{ port }}.conf:
  file.managed:
    - source: salt://redis/files/redis-upstart.conf.jinja
    - template: jinja
    - context:
      port: {{ port }}
      bin: redis-cluster-server
      conf: {{ conf.get('dir') }}{{ port }}/redis.conf

redis-cluster-{{ port }}:
  service.running

{% set unicast =  conf.get('unicast', false) %}
{%- for server, addrs in salt['mine.get'](unicast, 'network.ip_addrs', expr_form='compound').items() %}
firewall-redis-{{ addrs[0] }}:
 cmd.run:
   - name: ufw allow from {{ addrs[0] }} to any port {{ port }}

firewall-redis-cluster-bus{{ addrs[0] }}:
 cmd.run:
   - name: ufw allow from {{ addrs[0] }} to any port {{ port + 10000 }}
{%- endfor %}

{% endfor %}
