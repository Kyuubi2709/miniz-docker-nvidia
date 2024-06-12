FROM nvidia/cuda:12.4.1-base-ubuntu22.04 as nvidia

ENV DEBIAN_FRONTEND=noninteractive
ARG MINIZ_VERSION=v2.3c

RUN apt-get update && \
    apt-get install -y wget tar curl libcurl4 && \
    rm -rf /var/lib/apt/lists/*

RUN wget https://github.com/miniZ-miner/miniZ/releases/download/${MINIZ_VERSION}/miniZ_${MINIZ_VERSION}_linux-x64.tar.gz -O /tmp/miniZ.tar.gz && \
    mkdir -p /opt/miniz && \
    tar --strip-components=1 -xvf /tmp/miniZ.tar.gz -C /opt/miniz && \
    rm /tmp/miniZ.tar.gz

# Make the miniz binary executable
RUN chmod +x /opt/miniZ/miniZ

# Copy the entrypoint script into the image
COPY entrypoint.sh /opt/miniz/entrypoint.sh

# Make the entrypoint script executable
RUN chmod +x /opt/miniz/entrypoint.sh

# Set working directory
WORKDIR /opt/miniz

# Define environment variables with default values
ENV ALGO=""
ENV POOL=""
ENV WALLET=""
ENV EXTRA=""

# Set the entrypoint to the entrypoint script
ENTRYPOINT ["/opt/miniz/entrypoint.sh"]
