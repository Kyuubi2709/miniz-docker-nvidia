FROM nvidia/cuda:12.4.1-base-ubuntu22.04 as nvidia

ENV DEBIAN_FRONTEND=noninteractive
ARG RIGEL_VERSION=1.17.4

RUN apt-get update && \
    apt-get install -y wget tar curl libcurl4 && \
    rm -rf /var/lib/apt/lists/*

RUN wget https://github.com/rigelminer/rigel/releases/download/${RIGEL_VERSION}/rigel-${RIGEL_VERSION}-linux.tar.gz -O /tmp/rigel.tar.gz && \
    mkdir -p /opt/rigel && \
    tar --strip-components=1 -xvf /tmp/rigel.tar.gz -C /opt/rigel && \
    rm /tmp/rigel.tar.gz

# Make the rigel binary executable
RUN chmod +x /opt/rigel/rigel

# Copy the entrypoint script into the image
COPY entrypoint.sh /opt/rigel/entrypoint.sh

# Make the entrypoint script executable
RUN chmod +x /opt/rigel/entrypoint.sh

# Set working directory
WORKDIR /opt/rigel

# Define environment variables with default values
ENV ALGO=""
ENV POOL=""
ENV WALLET=""
ENV EXTRA=""

# Set the entrypoint to the entrypoint script
ENTRYPOINT ["/opt/rigel/entrypoint.sh"]
