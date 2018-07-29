# Our main tool is written in php, so we'll use a php base container
FROM drupaldocker/php:7.1-cli

# Set the working directory
WORKDIR /updatinator

# Copy the current directory contents into the container at our working directory
ADD . /updatinator

# Collect the components we need for this image
RUN apt-get update
RUN apt-get install -y jq

# Create an unpriviliged testuser
RUN groupadd -g 999 bot && \
    useradd -r -m -u 999 -g bot bot && \
    chown -R bot /usr/local && \
    chown -R bot /updatinator
USER bot

# Install and update updatinate
RUN curl "https://github.com/pantheon-systems/updatinate/releases/download/0.1.1/updatinate.phar" -o "/usr/local/bin/updatinate"
RUN chmod +x /usr/local/bin/updatinate
RUN updatinate self:update
