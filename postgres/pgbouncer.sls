pgbouncer:
    pkg:
        - installed
    service:
        - running
        - enable: True
        - require:
            - file: /etc/pgbouncer/pgbouncer.ini
            - file: /etc/pgbouncer/userlist.txt
            - file: /etc/default/pgbouncer
        - watch:
            - file: /etc/pgbouncer/pgbouncer.ini
            - file: /etc/pgbouncer/userlist.txt
            - file: /etc/default/pgbouncer

/etc/pgbouncer/pgbouncer.ini:
    file.managed:
        - source: salt://postgres/files/pgbouncer.ini
        - template: jinja
        - user: postgres
        - group: postgres
        - mode: 640
        - require:
            - pkg: pgbouncer

/etc/pgbouncer/userlist.txt:
    file.managed:
        - source: salt://postgres/files/userlist.txt
        - template: jinja
        - user: postgres
        - group: postgres
        - mode: 640
        - require:
            - pkg: pgbouncer

/etc/default/pgbouncer:
    file.managed:
        - source: salt://postgres/files/pgbouncer-default
        - user: root
        - group: root
        - mode: 644
        - require:
            - pkg: pgbouncer
