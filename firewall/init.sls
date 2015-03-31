ufw:
  pkg:
    - installed
  service:
    - running
    - enable: True

ufw-enable:
  cmd.run:
    - name: yes | ufw enable
    - require:
      - pkg: ufw

ufw-ssh:
  cmd.run:
    - name: ufw allow OpenSSH
    - require:
      - pkg: ufw
    - watch_in:
      - service: ufw

ufw-salt:
  cmd.run:
    - name: ufw allow Salt
    - require:
      - pkg: ufw
    - watch_in:
      - service: ufw

{% if salt['pillar.get']('extra-firewall-rules') %}
ufw-custom-rules:
  cmd.run:
    - name: |
      {% for key in pillar['extra-firewall-rules'] %}
        ufw {{ key }}
      {% endfor %}
{% endif %}

# TODO: deny all outoging traffic except newrelic and apt update sources?
