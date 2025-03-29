# hadolint global ignore=DL3008,DL3015,DL3029,DL3059,DL4006,SC2016
# Use a lightweight base image
FROM --platform=linux/amd64 debian:bullseye-slim

# Set non-interactive frontend for apt
ENV DEBIAN_FRONTEND=noninteractive

# Install required dependencies and Rust
RUN apt-get update && apt-get install -y \
    curl build-essential libssl-dev pkg-config nano \
    && curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Add Rust to PATH
ENV PATH="/root/.cargo/bin:$PATH"

# Verify Rust installation
RUN rustc --version

# Install Solana CLI
RUN curl -sSfL https://release.anza.xyz/stable/install | sh \
    && echo 'export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"' >> ~/.bashrc

# Add Solana CLI to PATH
ENV PATH="/root/.local/share/solana/install/active_release/bin:$PATH"

# Verify Solana CLI installation
RUN solana --version

# Update the Solana cluster configuration
# RUN solana config set --url mainnet-beta
RUN solana config set --url devnet
# RUN solana config set --url localhost
# RUN solana config set --url testnet

# Set working directory
WORKDIR /solana-token

# Default command to run a shell
CMD ["/bin/bash"]
