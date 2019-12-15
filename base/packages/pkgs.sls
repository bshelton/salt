{% from "packages/includes/map.jinja" import packages with context %}

{% set wanted_packages = packages.os_packages.wanted %}


{% if packages.os_packages.required is defined %}
{% set req_states = packages.os_packages.required.states %}

include:
  {% for state in req_states %}
  - {{ state }}
  {% endfor %}
{% endif %}


{% if packages.os_packages.required is defined %}
{% set req_packages = packages.os_packages.required.pkgs %}

require.packages:
  pkg.installed:
    - pkgs: {{ req_packages | json }}
    {% if req_states %}
    - require:
      {% for state in req_states %}
      - sls: {{ state }}
      {% endfor %}
    {% endif %}
{% endif %}



wanted.packages:
  pkg.installed:
    - pkgs: {{ wanted_packages | json }}
    {% if req_packages %}
    - require:
      {% for pkg in req_packages %}
      - pkg: {{ pkg }}
      {% endfor %}
    {% endif %}
    {% if req_states %}
     {% for state in req_states %}
       - sls: {{ state }}
      {% endfor %}
    {% endif %}