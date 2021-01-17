#!/bin/sh
exec "{{ certbot_script }}" -q renew
