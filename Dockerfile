# Our main tool is written in php, so we'll use a php base container
FROM drupaldocker/php:7.1-cli

# Set the working directory
WORKDIR /updatinator

# Copy the current directory contents into the container at our working directory
ADD . /updatinator

# install the PHP extensions we need
# (from https://github.com/docker-library/wordpress/blob/b3739870faafe1886544ddda7d2f2a88882eeb31/php7.1/fpm/Dockerfile)
RUN set -ex; \
    \
    savedAptMark="$(apt-mark showmanual)"; \
    \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        libjpeg-dev \
        libpng-dev \
    ; \
    \
    docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr; \
    docker-php-ext-install gd mysqli opcache zip;

# Install other packages we might need
RUN apt-get install -y jq

# Create an unpriviliged testuser
RUN groupadd -g 999 bot && \
    useradd -r -m -u 999 -g bot bot && \
    chown -R bot /usr/local && \
    chown -R bot /updatinator
USER bot

# Make a directory for the logs
RUN mkdir -p /updatinator/logs

# Install and update update-tool
RUN curl "https://github.com/pantheon-systems/update-tool/releases/download/0.5.20/update-tool.phar" -L -o "/usr/local/bin/update-tool"
RUN chmod +x /usr/local/bin/update-tool
RUN update-tool self:update
RUN update-tool --version

# Install wp-cli
RUN curl https://github.com/wp-cli/wp-cli/releases/download/v2.0.1/wp-cli-2.0.1.phar -L -o /usr/local/bin/wp
RUN chmod +x /usr/local/bin/wp
