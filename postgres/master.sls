include:
  - server

/etc/postgresql/9.3/main/postgresql.conf:
  file.managed:
    - user: postgres
    - group: postgres
    - mode: 755
    - makedirs: True

    - require:
      - pkg: postgresql-9.3

    - watch_in:
      - service: postgresql
