FROM elasticsearch:latest
MAINTAINER Jason Waldrip <jason@waldrip.net>

# Install confd
RUN wget https://github.com/kelseyhightower/confd/releases/download/v0.11.0/confd-0.11.0-linux-amd64 -O ./bin/confd
RUN chmod +x ./bin/confd
ADD confd /etc/confd

# Add Entrypoint
COPY ./bin ./bin
ENTRYPOINT [ "./bin/entrypoint" ]

# Default ENV
ENV ES_SHIELD_ADMIN_USERS=admin:admin
ENV ES_SHIELD_POWER_USERS=power:power
ENV ES_SHIELD_READONLY_USERS=readonly:readonly

# Default Command
CMD [ "elasticsearch" ]
