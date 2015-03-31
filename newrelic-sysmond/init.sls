# Based on https://gist.github.com/avimar/5968480

newrelic-sysmond:
  pkgrepo.managed:
    - humanname: New Relic Apt Repository
    - name: deb http://apt.newrelic.com/debian/ newrelic non-free
    - file: /etc/apt/sources.list.d/newrelic.list
    - keyid: 548C16BF
    - keyserver: keyserver.ubuntu.com

  pkg:
    - installed
    - require:
      - pkgrepo: newrelic-sysmond

  cmd.wait:
    - name: nrsysmond-config --set license_key={{ pillar['newrelic-sysmond']['license_key'] }}
    - watch:
      - pkg: newrelic-sysmond

  service:
    - running
    - watch:
      - cmd: newrelic-sysmond
