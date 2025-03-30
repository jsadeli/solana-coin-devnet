# hadolint global ignore=DL3029,DL3059,DL4006,SC2016
# Use a lightweight base image
FROM --platform=linux/amd64 rust:bookworm

# Install Solana CLI
# 'anza' is the current active maintainer of the Solana Validator (previously maintained by 'Solana Labs')
RUN curl -sSfL https://release.anza.xyz/stable/install | sh \
    && echo 'export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"' >> ~/.bashrc

# Add Solana CLI to PATH
ENV PATH="/root/.local/share/solana/install/active_release/bin:$PATH"

# Verify Solana CLI installation
RUN solana --version

# Update the Solana cluster configuration
RUN solana config set --url devnet

# Set working directory
WORKDIR /solana-token

# Default command to run a shell
CMD ["/bin/bash"]
