apt-transport-https: pkg.installed

passenger-repo:
  pkgrepo.managed:
    - humanname: Passenger Apt Repository
    - name: deb https://oss-binaries.phusionpassenger.com/apt/passenger {{ grains['oscodename'] }} main
    - file: /etc/apt/sources.list.d/passenger.list
    - keyid: 561F9B9CAC40B2F7
    - keyserver: keyserver.ubuntu.com
    - require:
        - pkg: apt-transport-https

passengerpkgs:
  pkg.installed:
    - pkgs:
      - ca-certificates
      - nginx-extras
      - passenger

nginx:
  file.managed:
    - name: /etc/nginx/nginx.conf
    - source: salt://passenger-nginx/files/nginx.conf

  service.running:
    - reload: True
    - watch:
      - file: nginx
