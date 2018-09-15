FROM openjdk:8
LABEL maintainer="Ignacio Cabrera <cabrerabywaters@gmail.com>"

ENV DEBIAN_FRONTEND noninteractive 

RUN cd /tmp && \
  curl -Lo /tmp/rundeck-cli.deb https://github.com/rundeck/rundeck-cli/releases/download/v1.0.29/rundeck-cli_1.0.29-1_all.deb && \
  dpkg -i /tmp/rundeck-cli.deb && rm /tmp/rundeck-cli.deb && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

CMD tail -f /dev/null