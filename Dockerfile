FROM clojure:boot-2.8.2
LABEL maintainer "price clark <price@eucleo.com>"

RUN apt-get -y update

RUN useradd -ms /bin/bash clj; exit 0
WORKDIR /home/clj
RUN mkdir clojure-scripting
WORKDIR clojure-scripting
COPY . .
RUN chown -R clj:clj /home/clj
USER clj

WORKDIR /home/clj/clojure-scripting/
RUN boot --help

WORKDIR /home/clj/clojure-scripting/client
RUN boot build
WORKDIR /home/clj/clojure-scripting/server
RUN boot build

FROM oracle/graalvm-ce:19.1.0
RUN yum -y update
RUN gu install native-image
WORKDIR /root
RUN mkdir -p /root/resources
COPY --from=0 /home/clj/clojure-scripting/client/target/clojure-scripting-client-0.1.0-SNAPSHOT-standalone.jar .
#-cp closh-zero.jar closh.zero.frontend.rebel
RUN native-image --report-unsupported-elements-at-runtime \
					--allow-incomplete-classpath \
					--verbose \
					-J-Xmx3G -J-Xms3G \
					--no-server \
					-H:+ReportExceptionStackTraces \
					--enable-all-security-services \
					-cp clojure-scripting-client-0.1.0-SNAPSHOT-standalone.jar clojure.scripting.client
					#-jar clojure-scripting-client-0.1.0-SNAPSHOT-standalone.jar
					#-H:Class=clojure.scripting.client \
					#-H:+FallbackExecutorMainClass=clojure.scripting.client \
#-H:+ReportUnsupportedElementsAtRuntime
RUN mv clojure-scripting-client-0.1.0-SNAPSHOT-standalone resources/clojure-script.bin
WORKDIR /root/resources
COPY --from=0 /home/clj/clojure-scripting/bin/clojure-script .
COPY --from=0 /home/clj/clojure-scripting/bin/clojure-script-server .
COPY --from=0 /home/clj/clojure-scripting/server/target/clojure-scripting-server-0.1.0-SNAPSHOT-standalone.jar clojure-script-server.jar

CMD ["/bin/bash", "-c", "cp /root/resources/* /mnt && chown -R $(stat -c \"%u:%g\" $MNT) /mnt"]
