include:
  - teamcity

teamcity-github-plugin:
  file.managed:
    - name: /home/teamcity/.BuildServer/plugins/teamcity.github.zip
    - source: http://teamcity.jetbrains.com/guestAuth/repository/download/bt398/128079:id/teamcity.github.zip
    - source_hash: md5=5497bbf2e172276020577c3a9ce3836c
    - require:
      - archive: /home/teamcity/deploy/
    - user: teamcity
    - group: teamcity
