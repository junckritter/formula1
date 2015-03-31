include:
  - postgres.server

postgres-user:
  postgres_user.present:
    - name: {{ pillar['postgres']['user'] }}
    - createdb: {{ pillar['postgres']['createdb'] }}
    - password: {{ pillar['postgres']['password'] }}
    - runas: postgres

postgres-db:
  postgres_database.present:
    - name: {{ pillar['postgres']['db'] }}
    - encoding: UTF8
    - lc_ctype: en_US.UTF8
    - lc_collate: en_US.UTF8
    - template: template0
    - owner: {{ pillar['postgres']['user'] }}
    - runas: postgres
    - require:
        - postgres_user: postgres-user