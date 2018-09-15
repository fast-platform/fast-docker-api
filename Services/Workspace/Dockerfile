FROM phusion/baseimage:0.10.1

LABEL maintainer="Ignacio Cabrera <cabrerabywaters@gmail.com>"


# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

RUN curl -LSs https://goo.gl/VZrL8t | sh

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*