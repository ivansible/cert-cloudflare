# ivansible.cert_cloudflare

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

Available variables are listed below, along with default values.

    certbot_group: ssl-cert
Members of this unix group will have read access to certificates.
By default this is the same group as the group used by `ssl-cert` ubuntu package.

    certbot_acme_server: acme-staging-v02.api.letsencrypt.org
ACME API endpoint to use: staging or production.

    certbot_cloudflare_email: username@email.com
    certbot_cloudflare_api_key: secret_api_key
Cloudflare credentials.

    certbot_certificates:
      - name: example.com
        active: true
        remove_existing: false
        update_existing: false
        domains:
          - example.com
List of certificates parameters.
`name` is required. `active` is an optional flag, defaults to true.
`remove_existing` and `update_existing` are optional flags defaulting to false.
`domains` is required list certificate domains,
it can include sublists (will be flattened).
Please note that certbot keeps first list item but sorts the remainder.

    certbot_acme_accounts:
      - name: staging
        active: true
        server: acme-staging-v02.api.letsencrypt.org
        account: 123
ACME account credentials.
`name` and `server` are required.
`active` is an optional flag, defaults to true.

    certbot_acme_server: acme-staging-v02.api.letsencrypt.org
This setting selects one of ACME accounts as active.

    certbot_renewal_enable: true
    certbot_certbot_renewal_cron_enable: true
You will rarely need to change these.


## Tags

- `cert_cf_install` -- install certbot packages
- `cert_cf_group` -- grant certbot group access to certificates
- `cert_replica_group` -- deliberately overlaps with role
                          [cert_replica](https://github.com/ivansible/cert-replica)
- `cert_cf_config` -- configure certbot with cloudflare
- `cert_cf_accounts` -- setup letsencrypt account registration
                        (includes subtag `cert_cf_renew_cert`)
- `cert_cf_certificate` -- produce first certificates
- `cert_cf_renewal` -- enable automatic renewals
- `cert_cf_all` -- all tasks


## Dependencies

None


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

Created in 2018-2020 by [IvanSible](https://github.com/ivansible)
