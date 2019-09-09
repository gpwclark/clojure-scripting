# Clojure scripting

Using Clojure for scripting... Yes we have Planck and Lumo, but what if we could have JVM Clojure with super fast boottime?

By using GraalVM to generate a thin client that talks to a JVM process via Clojure prepl we can have this!

## Demo
After the setup (see next section below) you will get this:

```
time examples/helloworld.clj
Hello World!
examples/helloworld.clj  0.01s user 0.01s system 65% cpu 0.035 total
```

Only the first time the server needs to be booted:
```
time examples/helloworld.clj
*** starting scripting server *** [1163ms]

Hello World!
examples/helloworld.clj  0.03s user 0.04s system 5% cpu 1.257 total
```
 
## Installation
 
Assumption is that you have `boot-clj` [[see instructions](https://github.com/boot-clj/boot#install)], `make` installed. And that you have a [GraalVM distribution](https://github.com/oracle/graal/releases/tag/vm-1.0.0-rc15) under `~/bin/graalvm-ce-1.0.0-rc15`.
 
```
make client-binary
make server-jar
```
 
You are now ready for some fast Clojure.
 
To kill the server:
 
```
make kill-server-processes
```

## Dockerized Installation
Included in this repository is a Dockerfile that builds the binaries in a
containerized environment so you don't have to have anything but docker installed
on your machine to run fast clojure scripts.

Build the container with
```
./build.sh
```

Mount the necessary files to a path on the host. Path chosen should be on $PATH
so clojure scripts can find it.
```
./run.sh ~/bin
```

Copyright (c) Jeroen van Dijk, Adgoji and contributors

Distributed under the Eclipse Public License 1.0 (same as Clojure).
 

