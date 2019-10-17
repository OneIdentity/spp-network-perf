# spp-network-perf
One Identity Safeguard for Privileged Passwords network performance testing tool

## Prerequisites
This tool was developed on a Linux workstation with the goal to keep the
prerequisites as minimal as possible. Using docker provides the ability to run
tooling in a container without changing what is installed on the host system.

Software Prerequisites:
- Linux (developed on Ubuntu 16.04 but any modern distro should work)
- bash (developed with version 4.4.20, probably 4.0+)
- curl (developed with version 7.58.0 but any should work)
- docker (developed with version 17.05.0-ce)

Hardware Prerequisites:
- Physical or Virtual
- --- _No performance minimums have been researched_ ---

It is important to make sure that the current user has appropriate permissions
to interact with the docker daemon. If you don't, you will see an error message
that looks like:

```
Got permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock: ...
```

The best way to fix this is to add your current user to the `docker` group.

```
$ sudo usermod -a -G docker $USER
```

Then, log out and log back in again to refresh your group memberships.

If the error still persists then you need to make sure the docker socket has a
group owner of `docker`. Then, try restarting the docker daemon, or reboot the
server. You can verify that docker is running properly when the following
command works.

```
$ docker run hello-world
```

## Installation
The easiest way to get spp-network-perf is to use `git`. To check out the source
code using `git` just type the following command:

```Bash
$ git clone https://github.com/OneIdentity/spp-network-perf.git
```

This will create a `spp-network-perf` directory in your current directory that
contains the entire spp-network-perf source tree.

If you do not have `git` then you can accomplish the same thing by running this
command line:

```Bash
$ curl -sSLO https://github.com/OneIdentity/spp-network-perf/archive/master.zip; unzip master.zip; rm master.zip; mv spp-network-perf-master spp-network-perf
```


