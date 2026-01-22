# Use official devcontainer base image
FROM mcr.microsoft.com/devcontainers/base:ubuntu-22.04

# Install system dependencies
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
    curl \
    wget \
    git \
    htop \
    tmux \
    vim \
    nano \
    build-essential \
    python3 \
    python3-pip \
    jq \
    unzip \
    ca-certificates \
    gnupg \
    lsb-release \
    bc \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Note: Node.js 20 is installed via devcontainer feature (see devcontainer.json)
# Claude Code CLI is installed in post-create.sh after Node.js is available

# Create workspace directory
RUN mkdir -p /workspace/ralph-workspace \
    && chown -R vscode:vscode /workspace

# Set working directory
WORKDIR /workspace

# Switch to vscode user for remaining operations
USER vscode

# Create directories for Ralph workflows
RUN mkdir -p /home/vscode/ralph-workspace

# Set default shell to bash
SHELL ["/bin/bash", "-c"]

# Add helpful aliases
RUN echo 'alias ll="ls -alh"' >> /home/vscode/.bashrc \
    && echo 'alias ralph-status="docker ps"' >> /home/vscode/.bashrc \
    && echo 'alias ralph-logs="docker logs"' >> /home/vscode/.bashrc

# Install Docker Compose (latest version)
RUN sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose \
    && sudo chmod +x /usr/local/bin/docker-compose

# Note: Node.js, npm, and claude verification happens in post-create.sh

# Default command
CMD ["/bin/bash"]
