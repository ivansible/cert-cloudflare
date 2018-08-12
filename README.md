# ivansible.letsencrypt-cloudflare
This role installs letsencrypt certbot with cloudflare wildcard challenge


## Requirements

None


## Variables

Available variables are listed below, along with default values.

    certbot_group: certbot-data
Members of this unix group will have read access to certificates.

    certbot_acme_server: acme-staging-v02.api.letsencrypt.org
ACME API endpoint to use: staging or production.

    certbot_cloudflare_email: username@email.com
    certbot_cloudflare_api_key: secret_api_key
Cloudflare credentials.

    certbot_certificates:
      - name: example.com
        active: yes
        remove_existing: no
        update_existing: no
        domains:
          - example.com
List of certificates parameters.

    certbot_acme_accounts:
      - name: staging
        active: yes
        server: acme-staging-v02.api.letsencrypt.org
        account: 123
ACME account credentials.


## Tags

- `le_cloudflare_install` -- install certbot packages
- `le_cloudflare_group` -- grant certbot group access to certificates
- `le_cloudflare_config` -- configure certbot with cloudflare
- `le_cloudflare_accounts` -- setup letsencrypt account registration
- `le_cloudflare_certificate` -- produce first certificates
- `le_cloudflare_renewal` -- enable automatic renewals


## Dependencies

None


## Example Playbook

    - hosts: vag1
      roles:
         - role: ivansible.letsencrypt-cloudflare
           certbot_acme_server: acme-v02.api.letsencrypt.org
           certbot_certificates:
             - name: mydomain.com
               active: yes
               remove_existing: no
               update_existing: no
               domains:
                 - mydomain.com
                 - "*.mydomain.com"
                 - "subdomain1.mydomain.org"
                 - "subdomain2.mydomain.net"


## License

MIT

## Author Information

Created in 2018 by [IvanSible](https://github.com/ivansible)
