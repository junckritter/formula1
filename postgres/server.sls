{% set data_dir = salt['pillar.get']('postgres:data_dir') %}

default_locale:
  cmd.run:
    - name: update-locale LC_ALL=en_US.UTF-8 && export LC_ALL=en_US.UTF-8
    - unless: cat /etc/default/locale | grep LC_ALL=en_US.UTF-8

postgresql_conf:
  file.managed:
    - name: /etc/postgresql/9.3/main/postgresql.conf
    - source: salt://postgres/files/postgresql.conf.jinja
    - user: postgres
    - group: postgres
    - template: jinja
    - require:
      - pkg: postgresql-9.3


{% if data_dir != '' %}
{{ data_dir }}:
  file.directory:
    - user: postgres
    - group: postgres
    - dir_mode: 755
{% endif %}

postgresql:
  pkgrepo.managed:
    - humanname: Postgresql Apt Repository
    - name: deb http://apt.postgresql.org/pub/repos/apt/ {{ grains['oscodename'] }}-pgdg main
    - file: /etc/apt/sources.list.d/postgresql.list
    - key_url: http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc

  pkg.installed:
    - names:
      - postgresql-9.3
      - postgresql-contrib-9.3
    - require:
      - pkgrepo: postgresql
      - cmd: default_locale

  file.managed:
    - name: /etc/postgresql/9.3/main/pg_hba.conf
    - source: salt://postgres/files/pg_hba.conf
    - user: postgres
    - group: postgres
    - require:
      - pkg: postgresql-9.3

  service.running:
    - watch:
      - file: /etc/postgresql/9.3/main/pg_hba.conf
