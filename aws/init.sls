awscli-install:
  cmd.run:
    - name: pip install awscli
    - require:
      - pkg: python-pip

awscli-config-dir:
  file.directory:
    - name: /home/ubuntu/.aws

#awscli-config:
#  file.append
