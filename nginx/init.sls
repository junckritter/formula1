{% set config_path = salt['pillar.get']('nginx:config_path', '/etc/nginx/nginx.conf') %}

nginx:
    pkg:
        - installed
    service:
        - running
        - watch:
            - file: {{ config_path }}

{{ config_path }}:
    file.managed:
        - source: salt://nginx/files/nginx.conf
        - template: jinja
