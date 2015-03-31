python-pip:
  pkg.installed

newrelic-plugin-agent:
  pip:
    - installed

newrelic-agent-config:
  file.managed:
    - template: jinja
    - name: /etc/newrelic/newrelic-plugin-agent.cfg
    - source: salt://newrelic-sysmond/files/agent.cfg

newrelic-agent-daemon:
  cmd.wait:
    - name: newrelic-plugin-agent -c /etc/newrelic/newrelic-plugin-agent.cfg
    - watch:
      - file: newrelic-agent-config

