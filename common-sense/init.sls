common-sense-pkgs:
  pkg.installed:
    - pkgs:
      - curl
      - htop
      - vim
      - tmux
      - screen
      - git-core
      - python-software-properties
      - python-apt

vimrc:
  file.managed:
    - name: /etc/vim/vimrc.local
    - source: salt://common-sense/files/vimrc

vim:
  pkg:
    - installed
    - require:
       - file: vimrc
