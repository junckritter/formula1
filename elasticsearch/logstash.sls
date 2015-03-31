logstash-repo:
  pkgrepo.managed:
    - name: deb http://packages.elasticsearch.org/logstash/{{ salt['pillar.get']('logstash:version') }}/debian stable main

logstash-packages:
  pkg.installed:
    - pkgs:
      - logstash
      - logstash-contrib

logstash-config:
  file.managed:
    - name: /etc/logstash/conf.d/logstash.conf
    - source: salt://elasticsearch/files/logstash.conf

logstash-vhost:
  file.managed:
    - name: /etc/nginx/sites-enabled/logstash.reactor.ms
    - source: salt://elasticsearch/files/logstash-vhost.conf
