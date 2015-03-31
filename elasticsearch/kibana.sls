kibana-file:
  archive.extracted:
    - name: /home/logger/www/
    - archive_format: tar
    - tar_options: xv
    - source: https://download.elasticsearch.org/kibana/kibana/kibana-3.1.1.tar.gz
    - source_hash: md5=42b0c28d271574dae6368a1651bb952a

kibana-vhost:
  file.managed:
    - template: jinja
    - name: /etc/nginx/sites-enabled/kibana.reactor.ms
    - source: salt://elasticsearch/files/kibana-vhost.conf

