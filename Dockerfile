# Our main tool is written in php, so we'll use a php base container
FROM drupaldocker/php:7.4-cli-2.x

# Set the working directory
WORKDIR /updatinator

# Copy the current directory contents into the container at our working directory
ADD . /updatinator

# Install other packages we might need
RUN apk update && apk add bash jq mysql mysql-client && \
  mkdir /scripts && \
  rm -rf /var/cache/apk/*

VOLUME ["/var/lib/mysql"]

COPY ./startup.sh /scripts/startup.sh
RUN chmod +x /scripts/startup.sh

EXPOSE 3306

# Create an unpriviliged testuser
RUN addgroup -S bot && adduser -S -G bot bot && \ 
    chown -R bot /usr/local && \
    chown -R bot /updatinator
USER bot

# Make a directory for the logs
RUN mkdir -p /updatinator/logs

# Install and update updatinate
RUN curl "https://github.com/pantheon-systems/updatinate/releases/download/0.5.4/updatinate.phar" -L -o "/usr/local/bin/updatinate"
RUN chmod +x /usr/local/bin/updatinate
RUN updatinate self:update
RUN updatinate --version

# Install wp-cli
RUN curl https://github.com/wp-cli/wp-cli/releases/download/v2.0.1/wp-cli-2.0.1.phar -L -o /usr/local/bin/wp
RUN chmod +x /usr/local/bin/wp

ENTRYPOINT ["/scripts/startup.sh"]
