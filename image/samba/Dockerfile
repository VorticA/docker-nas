# Use a stable Ubuntu base image
FROM ubuntu:22.04

# Avoid interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Update the system and install all necessary tools in one layer
RUN apt-get update && apt-get install -y \
    samba \
    sudo \
    wget \
    apt-transport-https \
    gnupg \
    && rm -rf /var/lib/apt/lists/*

# Install Webmin
RUN wget -qO - http://www.webmin.com/jcameron-key.asc | gpg --dearmor > /usr/share/keyrings/webmin.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/webmin.gpg] http://download.webmin.com/download/repository sarge contrib" > /etc/apt/sources.list.d/webmin.list
RUN apt-get update && apt-get install -y webmin && rm -rf /var/lib/apt/lists/*

# Create the initial 'webadmin' user and add to the 'sudo' group for admin rights
RUN useradd -m -s /bin/bash -G sudo webadmin

# Expose the ports for Samba and Webmin
EXPOSE 139 445 10000

# Copy the entrypoint script and make it executable
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Set the script as the entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
