# Automation: TLS with Certbot

This Bash script may be executed on a terminal or by a task scheduler such as [cron](https://linux.die.net/man/8/cron) and it does the following:

1. [Read](https://linux.die.net/man/1/read) from standard input the root domain and email address;
2. Generate a NGINX config with the root domain; and
3. Register and request a signed SSL/TLS certificate with [Certbot](https://certbot.eff.org/).

A detailed walk-through is available [here](https://kurtcms.org/automation-tls-with-certbot/).

## Table of Content

- [Getting Started](#getting-started)
  - [Git Clone](#git-clone)
  - [Permission](#permission)
  - [Dependencies](#dependencies)
  - [Run](#run)

## Getting Started

Get started in three simple steps:

1. [Download](#git-clone) a copy of the script;s
2. Provide the script with execute [permission](#permission);
3. Ensure the [dependencies](#dependencies) are in place; and
4. [Run](#run) the script manually.

### Git Clone

Download a copy of the script with `git clone`.

```shell
$ git clone https://github.com/kurtcms/certbot /app/certbot/
```

### Permission

Provide the script with execute permission

```shell
$ chmod +x /app/certbot/certbot.sh
```

### Dependencies

The script expects a sample NGINX config file by the name of `nginx.conf-sample` in the `../nginx-conf/` directory. It should be a working NGINX config file with `ROOT_DOMAIN` in place of the root domain.

It also requires [Docker](https://docs.docker.com/engine/install/) and [Docker Compose](https://docs.docker.com/compose/install/), together with a `docker-compose.yml` file in the parent directory of this script with two services by the name of `nginx` and `certbot`, backed by the `nginx` and `certbot` Docker images.

Be sure to have the dependencies in place. A reference is avaliable [here](https://github.com/kurtcms/docker-compose-wordpress-nginx-mysql).

### Run

Run the script

```shell
$ /app/certbot/certbot.sh
```

And have a signed SSL/TLS certificate installed