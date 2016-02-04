# Letsencrypt dockerized client

## Initial setup for persistence

Create data volumes for letsencrypt persistent data

```
export LE_DATA='letsencrypt-data'
docker run --name=$LE_DATA --entrypoint=/bin/true fabn/letsencrypt
```

## Certificate generation

Request a certificate. You need to run this command on the hostname you want to authenticate and allow incoming connections on port 443.

```
export EMAIL_ADDRESS=you@example.com
export AUTH_DOMAIN=example.com
docker run --rm -it --volumes-from=$LE_DATA -p 443:443 fabn/letsencrypt certonly --standalone --email $EMAIL_ADDRESS -d $AUTH_DOMAIN
```

If everything went fine you should get a message simlar to this

```
IMPORTANT NOTES:
 - Congratulations! Your certificate and chain have been saved at
   /etc/letsencrypt/live/$AUTH_DOMAIN/fullchain.pem. Your cert
   will expire on 2016-05-04. To obtain a new version of the
   certificate in the future, simply run Let's Encrypt again.
 - If you like Let's Encrypt, please consider supporting our work by:

   Donating to ISRG / Let's Encrypt:   https://letsencrypt.org/donate
   Donating to EFF:                    https://eff.org/donate-le
```

You can explore filesystem of data container with this command

```
docker run -ti --rm --volumes-from=$LE_DATA --entrypoint=/bin/bash fabn/letsencrypt
```

Certificate and keys will be saved under `/etc/letsencrypt` in data container its structure is the following

```
/etc/letsencrypt/
├── accounts
│   ├── acme-staging.api.letsencrypt.org
│   │   └── directory
│   │       └── 2c7aeaa7905e4d6178a223e598700fba
│   │           ├── meta.json
│   │           ├── private_key.json
│   │           └── regr.json
│   └── acme-v01.api.letsencrypt.org
│       └── directory
│           └── 71417a80639f7fa827b860f228fd1951
│               ├── meta.json
│               ├── private_key.json
│               └── regr.json
├── archive
│   └── $AUTH_DOMAIN
│       ├── cert1.pem
│       ├── chain1.pem
│       ├── fullchain1.pem
│       └── privkey1.pem
├── csr
│   ├── 0000_csr-letsencrypt.pem
│   ├── 0001_csr-letsencrypt.pem
│   └── 0002_csr-letsencrypt.pem
├── keys
│   ├── 0000_key-letsencrypt.pem
│   ├── 0001_key-letsencrypt.pem
│   └── 0002_key-letsencrypt.pem
├── live
│   └── $AUTH_DOMAIN
│       ├── cert.pem -> ../../archive/$AUTH_DOMAIN/cert1.pem
│       ├── chain.pem -> ../../archive/$AUTH_DOMAIN/chain1.pem
│       ├── fullchain.pem -> ../../archive/$AUTH_DOMAIN/fullchain1.pem
│       └── privkey.pem -> ../../archive/$AUTH_DOMAIN/privkey1.pem
└── renewal
    └── $AUTH_DOMAIN.conf
```

## Certificate Renewal

TBD