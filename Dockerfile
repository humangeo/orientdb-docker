FROM debian:jessie

# Docker will run as root while building the image (technically this is the
# default behavior, specifying here for clarity). This is also the user that
# OrientDB will run as.
USER root

# Add provisioning script
ADD docker-provision.sh /tmp/

# use custom configuration to start OrientDB w/supervisord
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN cd /tmp/ && sh docker-provision.sh

WORKDIR /opt/orientdb/
EXPOSE 2424
EXPOSE 2480

COPY docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

# Start OrientDB when the container starts
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
