# Solana Token

Making a Solana cryptocurrency token.

## Getting Started

1. Use the pre-configured Dockerfile to setup a devcontainer containing the latest versions of Rust and Solana CLI.
2. Start the devcontainer (may take a few minutes to complete the Docker image pull).

### Dockerfile

- For purposes of devcontainer environment on Apple ARM chips, we need the `--platform=linux/amd64`
  flag because the Solana CLI does not support[^1] aarch64 linux.

  Example:

  ```docker
  FROM --platform=linux/amd64 debian:bullseye-slim
  ```

- `anza` is the active maintainer of the Solana Validator (previously maintained by Solana Labs team).

## References

Getting free SOL (devnet only): [https://faucet.solana.com/](https://faucet.solana.com/)

[^1]: As of 2025-03-29.
