# ivansible.cert_cloudflare

[![Github Test Status](https://github.com/ivansible/cert-cloudflare/workflows/test/badge.svg?branch=master)](https://github.com/ivansible/cert-cloudflare/actions)
[![Ansible Galaxy](https://img.shields.io/badge/galaxy-ivansible.cert__cloudflare-68a.svg?style=flat)](https://galaxy.ansible.com/ivansible/cert_cloudflare/)

This role installs letsencrypt certbot with cloudflare wildcard challenge

Letsencrypt and cloudflare may fail if the same certificate is requested
from multiple machines in parellel. Therefore we have a pair of additional
roles if such certificate is required on multiple machines. The role
`ivansible.cert_master` is run against the same host as the
letsencrypt/cloudflare software and `ivansible.cert_replica` is run
on all other machines. Whenever a letsencrypt certificate is renewed on the
master machine, it will be pushed to replica hosts.

Certbot creates certificates and private keys with permissions 0644.
It rather prevents world access on the directory level.
Some software e.g. Postgresql server requires that private keys are not world-readable.
This role takes care of asigning appropriate group to private keys
and sets permissions of 0640. It also creates a post-renewal hook to do that.


## Requirements

None


## Variables

    certbot_acme_server: acme-staging-v02.api.letsencrypt.org
ACME API endpoint to use: staging or production.

    certbot_cloudflare_email: username@email.com
    certbot_cloudflare_api_key: secret_api_key
Cloudflare credentials.

    certbot_use_ecdsa: ...
If true, will use `ECDSA` certificates, else `RSA`.
`ECDSA` is supported from certbot version `1.10`.
The default is `true` for dockerized certbot, `false` otherwise.

    certbot_certificates:
      - name: example.com
        active: true
        existing: autoremove
        domains:
          - example.com
List of certificate parameters, they are:
  - `name` - required certificate name, usually the main domain;
  - `active` - optional flag, defaults to true,
               certificate is skipped if this is false;
  - `domains` - required list certificate domains,
                can include sublists (will be flattened);
  - `existing` - what to do if certificate already exists (optional),
                 one of:
    - `update` - update existing certificate;
    - `remove` - remove existing certificate;
    - `autoremove` - remove only if domains have changed, keep otherwise
                     (this is the default).

Please note that certbot keeps first list item but sorts the remainder.

    certbot_acme_accounts:
      - name: staging
        active: true
        server: acme-staging-v02.api.letsencrypt.org
        account: 123
        hash: 456
        creation_date: "1970-01-02T03:04:05Z"
        creation_host: localhost
        key_data: {_n: 1, _d: 2, _p: 3, _q: 4, dp: 5, dq: 6, qi: 7}

ACME account credentials.
`name` and `server` are required.
`active` is an optional flag, defaults to true.

    certbot_acme_server: acme-staging-v02.api.letsencrypt.org
This setting selects one of ACME accounts as active.

    certbot_renewal_enable: true
    certbot_certbot_renewal_cron_enable: true
You will rarely need to change these.

    certbot_max_logs: 12
Limits maximum number of rotated certbot logs.


## Tags

- `cert_cf_install` -- install certbot packages
- `cert_replica_group` -- deliberately overlaps with role
                          [cert_replica](https://github.com/ivansible/cert-replica)
- `cert_cf_config` -- configure certbot with cloudflare
- `cert_cf_accounts` -- setup letsencrypt account registration
                        (includes subtag `cert_cf_renew_cert`)
- `cert_cf_certs` -- setup certificates
- `cert_cf_renewal` -- enable automatic renewals
- `cert_cf_logs` -- fine-tune certbot logs
- `cert_cf_all` -- all tasks


## Dependencies

[ivansible.lin_base](https://github.com/ivansible/lin-base):
  - global flag `lin_compress_logs` enables compression of rotated logs

[ivansible.cert_base](https://github.com/ivansible/lin-base):
  - global settings `certbot_x_dir`, `certbot_script`, `certbot_group`, etc
  - common tasks in `install.yml`


## Example Playbook

    - hosts: vag1
      roles:
         - role: ivansible.cert_cloudflare
           certbot_acme_server: acme-v02.api.letsencrypt.org
           certbot_certificates:
             - name: mydomain.com
               active: true
               remove_existing: false
               update_existing: false
               domains:
                 - mydomain.com
                 - "*.mydomain.com"
                 - "subdomain1.mydomain.org"
                 - "subdomain2.mydomain.net"


## License

MIT

## Author Information

Created in 2018-2021 by [IvanSible](https://github.com/ivansible)
