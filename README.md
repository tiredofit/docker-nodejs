# tiredofit/nodejs

[![Build Status](https://img.shields.io/docker/build/tiredofit/nodejs.svg)](https://hub.docker.com/r/tiredofit/nodejs)
[![Docker Pulls](https://img.shields.io/docker/pulls/tiredofit/nodejs.svg)](https://hub.docker.com/r/tiredofit/nodejs)
[![Docker Stars](https://img.shields.io/docker/stars/tiredofit/nodejs.svg)](https://hub.docker.com/r/tiredofit/nodejs)
[![Docker Layers](https://images.microbadger.com/badges/image/tiredofit/nodejs.svg)](https://microbadger.com/images/tiredofit/nodejs)

# Introduction

Dockerfile to build a [NodeJS](https://nodejs.org) base image for building/serving applications.

This Container uses [Alpine 3.10](https://hub.docker.com/r/tiredofit/alpine) and [Debian:buster](https://hub.docker.com/r/tiredofit/debian) as a base.



[Changelog](CHANGELOG.md)

# Authors

- [Dave Conroy](https://github.com/tiredofit)

# Table of Contents

- [Introduction](#introduction)
	- [Changelog](CHANGELOG.md)
- [Prerequisites](#prerequisites)
- [Dependencies](#dependendcies)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Configuration](#configuration)
	- [Data Volumes](#data-volumes)
	- [Database](#database)
	- [Environment Variables](#environmentvariables)   
	- [Networking](#networking)
- [Maintenance](#maintenance)
	- [Shell Access](#shell-access)
- [References](#references)


# Prerequisites

None.

# Dependencies

None.

# Installation

Automated builds of the image are available on [Docker Hub](https://tiredofit/nodejs) and is the recommended method of installation.


```bash
docker pull tiredofit/nodejs:(image tag)
```


The following image tags are available:

* `4:latest` - Node JS 4 - Alpine 3.6
* `4:debian-latest` - Node JS 4 - Debian Stretch
* `6:latest` - Node JS 6 - Alpine 3.8
* `6:debian-latest` - Node JS 6 - Debian Stretch
* `8:latest` - Node JS 8 - Alpine 3.8
* `8:debian-latest` - Node JS 8 - Debian Stretch
* `8:latest` - Node JS 8 - Alpine 3.10
* `10:debian-latest` - Node JS 10 - Debian Stretch
* `10:latest` - Node JS 10 - Alpine 3.10
* `12:debian-latest` - Node JS 12 - Debian Stretch
* `12:latest` - Node JS 12 - Alpine 3.10
* `12:debian-latest` - Node JS 12 - Debian Stretch
* `12:latest` - Node JS 12 - Alpine 3.10
* `13:debian-latest` - Node JS 13 - Debian Buster
* `13:latest` - Node JS 13 - Alpine 3.10


# Quick Start

* The quickest way to get started is using [docker-compose](https://docs.docker.com/compose/). See the examples folder for a working [docker-compose.yml](examples/docker-compose.yml) that can be modified for development or production use.

* Set various [environment variables](#environment-variables) to understand the capabilities of this image.
* Map [persistent storage](#data-volumes) for access to configuration and data files for backup.
* Map [Network Ports](#networking) to allow external access.

Start the container using:

```bash
docker-compose up
```

## Data-Volumes

This a base image, so no data volumes are exposed.


## Environment Variables

No Environment Variables are exposed other than the [base environment variables](https://hub.docker.com/r/alpine)..

## Networking

No Networking Ports are exposed.

#### Shell Access

For debugging and maintenance purposes you may want access the containers shell. 

```bash
docker exec -it nodejs bash
```

# References

* https://nodejs.org
