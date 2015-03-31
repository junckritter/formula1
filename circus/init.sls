install_packages:
    pkg.installed:
        - pkgs:
            - python-pip
            - python-dev

install_circus:
    pip.installed:
        - name: circus
        - user: root
        - upgrade: True
        - require:
            - pkg: install_packages

/etc/circus/conf.d:
    file.directory:
        - makedirs: True

/etc/circus/circus.ini:
    file.managed:
        - source: salt://circus/files/main_conf.ini
        - require:
            - file: /etc/circus/conf.d

/etc/init/circus.conf:
    file.managed:
        - source: salt://circus/files/upstart.conf

circuse_service:
    service:
        - running
        - name: circus
        - enable: True
        - watch:
            - file: /etc/circus/circus.ini
        - require:
            - pip: install_circus
            - file: /etc/init/circus.conf
