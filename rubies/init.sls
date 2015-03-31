rbenv-deps:
  pkg.installed:
    - pkgs:
      - git-core
      - build-essential
      - libreadline-dev
      - libssl-dev
      - libyaml-dev
      - libxml2-dev
      - libxslt1-dev
      - zlib1g-dev
      - libffi-dev

{% for version in pillar.get('rubies', ['2.2.0']) %}
ruby-{{ version }}:
  rbenv.installed:
    {%- if loop.first %}
    - default: True
    {%- endif %}
    - require:
      - pkg: rbenv-deps

  cmd.run:
    - name: /usr/local/rbenv/versions/{{ version }}/bin/gem install bundler --no-ri --no-rdoc
    - creates: /usr/local/rbenv/versions/{{ version }}/bin/bundle
    - require:
      - rbenv: ruby-{{ version }}

{% endfor %}

rbenv-rehash:
  cmd.run:
    - name: RBENV_ROOT=/usr/local/rbenv /usr/local/rbenv/bin/rbenv rehash
