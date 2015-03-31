include:
  - firewall

{% set unicast =  salt['pillar.get']('elasticsearch:unicast', false) %}
{% if unicast %}
{%- for server, addrs in salt['mine.get'](unicast, 'network.ip_addrs', expr_form='pcre').items() %}
firewall-elastic-{{ addrs[0] }}:
 cmd.run:
   - name: ufw allow from {{ addrs[0] }} to any port 9300
{%- endfor %}
{%- endif %}
