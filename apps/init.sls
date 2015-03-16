apps-common-deps:
  pkg.installed:
    - pkgs:
      - nodejs # asset compilation
      - libpq-dev # pg gem
      - libcurl4-openssl-dev # libcurl based gems

logrotate:
  pkg:
    - installed

apps:
  group.present

# make gems installable from apps
/usr/local/rbenv:
  file.directory:
    - group: apps
    - recurse: # TODO this runs every time !
      - group
    - require:
      - group: apps

include:
  - rubies
  - passenger-nginx

/etc/nginx/nginx.conf:
  file.managed:
    - source: salt://apps/files/nginx.conf
    - template: jinja
    - watch_in:
      - service: nginx

{% set http_done = 0 %}
{% set https_done = 0 %}

{% for name, config in pillar['apps'].iteritems() %}

{{ name }}_application:
  user.present:
    - name: {{ name }}
    - groups:
      - apps
    - shell: /bin/bash

  ssh_auth.present:
    - user: {{ name }}
    - names:
  {%- for key in config['deploy-keys'] %}
      - {{ key }}
  {%- endfor %}

# symlink system-wide rbenv install
/home/{{ name }}/.rbenv:
  file.symlink:
    - target: /usr/local/rbenv
    - group: apps

# rbenv setup
/home/{{ name }}/.bashrc:
  file.managed:
    - source: salt://apps/files/bashrc
    - user: {{ name }}

# gem defaults
/home/{{ name }}/.gemrc:
  file.managed:
    - source: salt://apps/files/gemrc
    - user: {{ name }}

# bundler defaults
/home/{{ name }}/.bundle/config:
   file.managed:
    - source: salt://apps/files/bundle-config
    - template: jinja
    - makedirs: True
    - user: {{ name }}

# irb defaults
/home/{{ name }}/.irbrc:
   file.managed:
    - source: salt://apps/files/irbrc
    - makedirs: True
    - user: {{ name }}

{%- if 'ssl_key' in config %}

{{ name }}-ssl-key:
  file.managed:
    - name: /etc/nginx/ssl/{{ name }}.key
    - contents_pillar: apps:{{ name }}:ssl_key
    - makedirs: True
    - watch_in:
      - service: nginx

{{ name }}-ssl-cert:
  file.managed:
    - name: /etc/nginx/ssl/{{ name }}.crt
    - contents_pillar: apps:{{ name }}:ssl_cert
    - makedirs: True
    - watch_in:
      - service: nginx

{%- endif %}

/etc/nginx/sites-available/{{ name }}:
  file.managed:
    - source: salt://apps/files/nginx-app.conf
    - template: jinja
    - context:
        name: {{ name }}
        domain: {{ config['domain'] }}
        www: {{ config.get('www', True) }}
        https: {{ 'ssl_key' in config }}
        http_allowed_domains: {{ config.get('http_allowed_domains', []) }}
        environment: {{ config.get('environment', False) }}
    - watch_in:
      - service: nginx

/etc/nginx/sites-enabled/{{ name }}:
  file.symlink:
    - target: /etc/nginx/sites-available/{{ name }}
    - require:
      - file: /etc/nginx/sites-available/{{ name }}
    - watch_in:
      - service: nginx

{% if not http_done %}
{% set http_done = 1 %}

firewall-http:
 cmd.run:
   - onlyif: ufw version
   - name: ufw allow 'Nginx HTTP'
{% endif %}

{% if config.get('ssl_cert') and not https_done %}
{% set https_done = 1 %}

firewall-https:
 cmd.run:
   - onlyif: ufw version
   - name: ufw allow 'Nginx HTTPS'

{% endif %}

/etc/logrotate.d/{{ name }}:
  file.managed:
    - source: salt://apps/files/logrotate.conf
    - template: jinja
    - context:
        name: {{ name }}

{% endfor %}
