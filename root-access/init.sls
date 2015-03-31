root-access:
  ssh_auth.present:
    - user: root
    - names:
  {% for key in pillar['root-access'] %}
      - {{ key }}
  {% endfor %}
