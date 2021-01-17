#!/bin/sh
find "{{ certbot_dir }}/archive" -name "privkey*.pem" \
    | xargs -r chgrp "{{ certbot_group }}"
find "{{ certbot_dir }}/archive" -name "privkey*.pem" \
    | xargs -r chmod g+r,o=
