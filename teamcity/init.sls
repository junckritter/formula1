teamcity:
  user.present:
  - shell: /bin/bash

teamcity-server:
  archive.extracted:
    - name: /home/teamcity/deploy/
    - source: http://download.jetbrains.com/teamcity/TeamCity-9.0.tar.gz
    # - source_hash: md5=756a6fd3a96da0da09d30b9536eb974a
    - source_hash: md5=cc949b85427457ac06dea35d1df41bbe
    - if_missing: /home/teamcity/deploy/TeamCity/
    - archive_format: tar
    - tar_options: vx
    - require:
      - user: teamcity

teamcity-server-permissions:
  file.directory:
    - name: /home/teamcity/deploy/
    - user: teamcity
    - group: teamcity
    - recurse:
      - user
      - group
    - require:
      - archive: teamcity-server
