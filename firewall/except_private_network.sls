{{ set conf = pillar['firewall'] }}

ufw:
  pkg:
    - installed
  service:
    - running
    - enable: True

ufw-enable-private-network:
  cmd.run:
    - name: ufw allow in on {% conf['private_network_interface'] %}

ufw-enable:
  cmd.run:
    - name: yes | ufw enable
    - require:
      - pkg: ufw

{% if salt['pillar.get']('firewall:rules') %}
ufw-custom-rules:
  cmd.run:
    - name: |
      {% for key in conf['rules'] %}
        ufw {{ key }}
      {% endfor %}
{% endif %}
