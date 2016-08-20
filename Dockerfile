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
ENV ES_NETWORK_HOST 0.0.0.0
ENV PORT 9200

# Default Command
CMD [ "elasticsearch" ]
