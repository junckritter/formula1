include:
  - firewall

firewall-enable-api:
  cmd.run:
    - name: ufw allow to any port 9200

firewall-enable-intranode:
  cmd.run:
    - name: ufw allow to any port 9300

firewall-enable-multicast:
  cmd.run:
    - name: ufw allow to any port 54328