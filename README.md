# Solana Token

Making a Solana cryptocurrency token.

- Why? Because it's just for fun!
- Why Solana? It's a very fast and cheap blockchain network, also it runs on Rust (instead of Ethereum's javascript-inspired Solidity).

## Getting Started

1. Use the pre-configured [Dockerfile](Dockerfile) to run a [devcontainer](.devcontainer/devcontainer.json).

   - Setup the latest stable versions of Rust and Solana CLI.
   - For purposes of using devcontainer on Apple ARM chips, we need the `--platform=linux/amd64` flag
     because the Solana CLI does not support[^1] _aarch64 linux_ (devcontainer on Apple ARM chips).
     Since the Docker container is running non-natively, we sacrifice a little bit of performance
     for a clean virtualization setup. For those running on x86/64, you can safely remove this flag.

     Example:

     ```dockerfile
     FROM --platform=linux/amd64 debian:bullseye-slim
     ```

   - `anza` is the current active maintainer of the Solana Validator (previously maintained by
     Solana Labs team).

1. Build and run the devcontainer (approx. ~2.2 GB image).
1. Start making a _fake_ Solana token!

## Creating a Solana Token

- Create an account that will own the token we're creating.

```sh
solana-keygen grind --starts-with dad:1
```

## Get free SOLs

Getting free SOL (devnet only): [https://faucet.solana.com/](https://faucet.solana.com/)

## Useful Commands

| Command                                                | Description                                     |
|--------------------------------------------------------|-------------------------------------------------|
| `solana config get`                                    | get the current configuration.                  |
| `solana config set --keypair ${HOME}/new-keypair.json` | set the default keypair.                        |
| `solana balance`                                       | check the current SOL balance for this account. |

## References

- [Solana docs](https://solana.com/docs/intro/installation)
- [anza docs](https://docs.anza.xyz/cli/intro)

[^1]: As of release [v2.2.4](https://github.com/anza-xyz/agave/releases/tag/v2.2.4) (2025-03-29).
