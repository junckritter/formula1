{% for name, config in pillar['sidekiq'].iteritems() %}

/etc/init/sidekiq-{{ name }}.conf:
  file.managed:
    - source: salt://sidekiq/files/upstart.conf
    - template: jinja
    - mode: 644
    - context:
      user: {{ name }}
      app: {{ config['app'] }}
      environment: {{ config['environment'] }}
      pre_start_script: {{ config['pre_start_script'] }}

{{ name }}-sidekiq-sudoers:
  file.append:
    - name: /etc/sudoers
    - source: salt://sidekiq/files/sudoers.conf
    - template: jinja
    - context:
        user: {{ name }}

{% endfor %}
