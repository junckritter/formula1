fail2ban:
  pkg:
    - installed
  service:
    - running
  require:
    - sls: firewall

/etc/fail2ban/action.d/ufw-ssh.conf:
  file.managed:
    - source: salt://security/files/ufw-ssh.conf
    - watch_in:
      - service: fail2ban

/etc/fail2ban/jail.local:
  file.managed:
    - source: salt://security/files/jail.local
    - watch_in:
      - service: fail2ban

ssh:
  service.running:
    - require:
      - file: /etc/ssh/sshd_config

/etc/ssh/sshd_config:
  file.append:
    - text: PasswordAuthentication no
    - watch_in:
      - service: ssh

# Protect ICMP attacks
net.ipv4.icmp_echo_ignore_broadcasts:
  sysctl.present:
    - value: 1

# Turn on protection for bad icmp error messages
net.ipv4.icmp_ignore_bogus_error_responses:
  sysctl.present:
    - value: 1

# Turn on syncookies for SYN flood attack protection
net.ipv4.tcp_syncookies:
  sysctl.present:
    - value: 1

# Log suspcicious packets, such as spoofed, source-routed, and redirect
net.ipv4.conf.all.log_martians:
  sysctl.present:
    - value: 1
net.ipv4.conf.default.log_martians:
  sysctl.present:
    - value: 1

# Disables these ipv4 features, not very legitimate uses
net.ipv4.conf.all.accept_source_route:
  sysctl.present:
    - value: 0
net.ipv4.conf.default.accept_source_route:
  sysctl.present:
    - value: 0

# Enables RFC-reccomended source validation (dont use on a router)
net.ipv4.conf.all.rp_filter:
  sysctl.present:
    - value: 1
net.ipv4.conf.default.rp_filter:
  sysctl.present:
    - value: 1

# Make sure no one can alter the routing tables
net.ipv4.conf.all.accept_redirects:
  sysctl.present:
    - value: 0
net.ipv4.conf.default.accept_redirects:
  sysctl.present:
    - value: 0
net.ipv4.conf.all.secure_redirects:
  sysctl.present:
    - value: 0
net.ipv4.conf.default.secure_redirects:
  sysctl.present:
    - value: 0

# Turn on execshild
kernel.randomize_va_space:
  sysctl.present:
    - value: 1
