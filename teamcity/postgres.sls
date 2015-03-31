include:
  - teamcity

teamcity-postgres-driver:
  file.managed:
    - name: /home/teamcity/.BuildServer/lib/jdbc/postgresql-9.3-1101.jdbc41.jar
    - source: http://jdbc.postgresql.org/download/postgresql-9.3-1101.jdbc41.jar
    # - source_hash: md5=0979f86b7856a6200a273191284f3655
    - require:
      - archive: /home/teamcity/deploy/
    - user: teamcity
    - group: teamcity
