# deploy-freenas

deploy-freenas.py is a Python script to deploy TLS certificates to a FreeNAS server using the FreeNAS API.  This should ensure that the certificate data is properly stored in the configuration database, and that all appropriate services use this certificate.  It's intended to be called from a Let's Encrypt client like [acme.sh](https://github.com/Neilpang/acme.sh) after the certificate is issued, so that the entire process of issuance (or renewal) and deployment can be automated.

This fork of [danb35/deploy-freenas](https://github.com/danb35/deploy-freenas) is packaged to be deployed as a Docker container.

## Installation

Run a single excecution of the script:

```sh
docker run -it --rm --name deploy-freenas -v deploy-freenas:/deploy-freenas dcroper/deploy-freenas:latest
```

Run as a daemon:

```sh
docker run -it --rm --name deploy-freenas -v deploy-freenas:/deploy-freenas dcroper/deploy-freenas:latest deamon
```

Within the daemon container you can execute `deploy_freenas` to run the script as the Docker image adds the script to the default `$PATH`.

## Usage

The relevant configuration takes place in the `/deploy-freenas/deploy_config` file.  The Docker image will create a `deploy_config` file based on `deploy_config.example` if none exists in the config volume.  Its format is as follows:

```cfg
[deploy]
password = YourReallySecureRootPassword
cert_fqdn = foo.bar.baz
connect_host = baz.bar.foo
verify = false
privkey_path = /some/other/path
fullchain_path = /some/other/other/path
protocol = https://
port = 443
ftp_enabled = false
```

Everything but the password is optional, and the defaults are documented in `depoy_config.example`.

Once you've prepared `deploy_config`, you can run `deploy_freenas.py`.  The intended use is that it would be called by your ACME client after issuing a certificate.  With acme.sh, for example, you'd add `--deploy-hook "/path/to/deploy_freenas.py"` to your command.
