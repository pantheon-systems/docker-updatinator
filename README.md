# Updatinator Docker Image

[![docker pull quay.io/pantheon-public/docker-updatinator](https://img.shields.io/badge/image-quay-blue.svg)](https://quay.io/repository/pantheon-public/docker-updatinator)

This is the source Dockerfile for the [pantheon-public/docker-updatinator](https://quay.io/repository/pantheon-public/docker-updatinator) docker image, used by the [updatinator](https://github.com/pantheon-systems/updatinator) automation processes

## Usage
In CircleCI 2.0:
```
  docker:
    - image: quay.io/pantheon-public/docker-updatinator:1.x
```

## Image Contents

- [Update tool](https://github.com/pantheon-systems/update-tool)
- [jq](https://stedolan.github.io/jq/)

More may be added later.
