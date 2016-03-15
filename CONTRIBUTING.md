# Contributing

Thanks for your interest in improving this project! Here is some information to
help you get started.


## How it is built

This project is built using Docker Hub's
[Autobuild feature](https://docs.docker.com/docker-hub/builds/). Commits to the
*develop* branch will trigger a new build that will be tagged as "latest".

Additionally, tags that follow a semantic version number format (i.e.
MAJOR.MINOR.PATH) will trigger a build that is tagged with that version.


## Getting Started

Before you get started, you will need:

* Docker
* A GitHub account


## Reporting Problems & Requesting Features

Use [GitHub Issues](https://github.com/humangeo/orientdb-docker/issues) to
report problems or request features. Please be as descriptive as possible.


## Making Changes

A typical workflow for introducing changes and deploying them involves:

* Commiting/merging changes to *develop*

    Keep in mind that changes to *develop* trigger a build that gets deployed to
    Docker Hub. To avoid this, use a topic branch and merge it (or submit a
    merge request) when it is ready.

* Testing it out

    It usually takes a few minutes for a build to complete and get Deployed on
    Docker Hub. When it is ready, you should pull it down and test it out:

        $ docker pull humangeo/orientdb:latest
        $ docker run \
            --rm \
            -it \
            -e ODB_ADMIN_PASSWORD=password \
            -p 2480:2480 \
            -p 2424:2424 \
            humangeo/orientdb

* Creating a release

    When you are satisfied with the changes on *develop*, they should be merged
    into *master* and tagged with a semantic version number. In the unlikely
    event that you need to rebuild a specific version, add a dash followed by a
    unique qualifier to the semantic version (e.g. *1.0.0-build2*).
