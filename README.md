# hub.docker.com/r/tiredofit/nodejs

[![Docker Pulls](https://img.shields.io/docker/pulls/tiredofit/nodejs.svg)](https://hub.docker.com/r/tiredofit/nodejs)
[![Docker Stars](https://img.shields.io/docker/stars/tiredofit/nodejs.svg)](https://hub.docker.com/r/tiredofit/nodejs)
[![Docker Layers](https://images.microbadger.com/badges/image/tiredofit/nodejs.svg)](https://microbadger.com/images/tiredofit/nodejs)

## Introduction

Dockerfile to build a [NodeJS](https://nodejs.org) base image for building/serving applications.
This container uses [Alpine](https://hub.docker.com/r/tiredofit/alpine) and [Debian](https://hub.docker.com/r/tiredofit/debian) as a base.

[Changelog](CHANGELOG.md)

## Authors

- [Dave Conroy](https://github.com/tiredofit)

## Table of Contents

- [Introduction](#introduction)
- [Authors](#authors)
- [Table of Contents](#table-of-contents)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
	- [Quick Start](#quick-start)
	- [Data-Volumes](#data-volumes)
	- [Environment Variables](#environment-variables)
	- [Networking](#networking)
	- [Shell Access](#shell-access)
- [References](#references)


## Prerequisites

None.

# Dependencies

None.

## Installation

Automated builds of the image are available on [Docker Hub](https://hub.docker.com/r/tiredofit/nodejs) and is the recommended method of installation.


```bash
docker pull tiredofit/nodejs:(image tag)
```


The following image tags are available:

* `10:latest` - Node JS 10 - Alpine 3.13
* `10:debian-latest` - Node JS 10 - Debian Buster
* `12:latest` - Node JS 12 - Alpine 3.13
* `12:debian-latest` - Node JS 12 - Debian Buster
* `14:latest` - Node JS 14 - Alpine 3.13
* `16:latest` - Node JS 16 - Alpine 3.13
* `14:debian-latest` - Node JS 14 - Debian bBuster
* `16:debian-latest` - Node JS 16 - Debian bBuster


### Quick Start

* The quickest way to get started is using [docker-compose](https://docs.docker.com/compose/).
* Set various [environment variables](#environment-variables) to understand the capabilities of this image.
* Map [persistent storage](#data-volumes) for access to configuration and data files for backup.
* Map [Network Ports](#networking) to allow external access.

Start the container using:

```bash
docker-compose up
```

### Data-Volumes

This a base image, so no data volumes are exposed.


### Environment Variables

No environment variables are exposed other than the [base environment variables](https://hub.docker.com/r/alpine).

### Networking

No networking ports are exposed.

### Shell Access

For debugging and maintenance purposes you may want access the containers shell.

```bash
docker exec -it nodejs bash
```

## References

* https://nodejs.org