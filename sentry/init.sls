reactor_packages:
    pkg.installed:
        - pkgs:
            - libevent-dev
            - libpq-dev
            - git-core
            - python-dev
            - python-pip
            - supervisor

sentry-pip:
  pip.installed:
    - requirements: salt://sentry/files/requirements.txt

sentry-config:
  file.managed:
    - name: /home/logger/www/sentry.conf
    - source: salt://sentry/files/sentry.conf

sentry-vhost:
  file.managed:
    - name: /etc/nginx/sites-enabled/sentry.stv.io
    - source: salt://sentry/files/sentry-vhost.conf

sentry-supervisor-config:
  file.managed:
    - name: /etc/supervisor/conf.d/sentry.conf
    - source: salt://sentry/files/sentry-supervisor.conf

