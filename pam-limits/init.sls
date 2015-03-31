pam-limits-common:
  file.append:
    - name: /etc/pam.d/common-session
    - text: session required pam_limits.so

pam-limits-noninteractive:
  file.append:
    - name: /etc/pam.d/common-session-noninteractive
    - text: session required pam_limits.so
