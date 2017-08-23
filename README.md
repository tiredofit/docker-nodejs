# tiredofit/nodejs

# Introduction

Dockerfile to build a [NodeJS Server](https://nodejs.org) 

This Container uses [Alpine 3.6] as a base.



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
* `6:latest` - Node JS 6 - Alpine edge
* `latest` - Node JS 6 - Alpine edge


# Quick Start

* The quickest way to get started is using [docker-compose](https://docs.docker.com/compose/). See the examples folder for a working [docker-compose.yml](examples/docker-compose.yml) that can be modified for development or production use.

* Set various [environment variables](#environment-variables) to understand the capabilities of this image.
* Map [persistent storage](#data-volumes) for access to configuration and data files for backup.
* Map [Network Ports](#networking) to allow external access.

Start openldap using:

```bash
docker-compose up
```
__NOTE__: Please allow up to 1 minutes for the application to start.


## Data-Volumes


This a base image, so no data volumes are exposed.


## Environment Variables

No Environment Variables are exposed.

## Networking

No Networking Ports are exposed.

#### Shell Access

For debugging and maintenance purposes you may want access the containers shell. 

```bash
docker exec -it nodejs bash
```

# References

* https://nodejs.org
