FROM nvidia/cuda:12.4.1-base-ubuntu22.04 as nvidia

ENV DEBIAN_FRONTEND=noninteractive
ARG MINIZ_VERSION=v2.3c

RUN apt-get update && \
    apt-get install -y wget tar curl libcurl4 && \
    rm -rf /var/lib/apt/lists/*

RUN wget https://github.com/miniZ-miner/miniZ/releases/download/${MINIZ_VERSION}/miniZ_${MINIZ_VERSION}_linux-x64.tar.gz:61ea0801f5222a766e18da72b0124e20f88af9abca0adab70f7c0b5db7d7b9ab -O /tmp/miniz.tar.gz && \
    mkdir -p /opt/miniz && \
    tar --strip-components=1 -xvf /tmp/miniz.tar.gz -C /opt/miniz && \
    rm /tmp/miniz.tar.gz

# Make the miniz binary executable
RUN chmod +x /opt/miniz/miniz

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
