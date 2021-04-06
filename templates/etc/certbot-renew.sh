#!/bin/sh
#set -x
script="{{ certbot_script }}"
{% for item in certbot_certificates %}
{% set name = item.name %}
{% set active = item.active |default(true) |bool %}
{% set rsa = item.rsa |default(false) |bool %}
{% if active %}
$script -q renew --cert-name {{ name }}{% if rsa %} --key-type rsa{% endif %}

{% endif %}
{% endfor %}
