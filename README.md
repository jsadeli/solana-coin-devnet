# Solana Token

Making a Solana cryptocurrency token.

- Why? Because it's fun!
- Why Solana? Because it's a very fast and cheap blockchain network, also it runs on Rust
  (instead of Ethereum's Javascript-inspired Solidity).
  - Ethereum, one of the most popular blockchain, transactions typically take anywhere from 15s to 5min,
    with a gas fee that historically reached 2,000 gwei (~$200)[^1] in 2021.
  - As a comparison, Solana's transactions are typically completed in under 1s with fees of less than $0.01.

## Getting Started

1. Use the pre-configured [Dockerfile](Dockerfile) to run a [devcontainer](.devcontainer/devcontainer.json).

   - Setup the latest stable versions of Rust and Solana CLI.
   - For purposes of using devcontainer on Apple ARM chips, we need the `--platform=linux/amd64` flag
     because the Solana CLI does not support[^2] _aarch64 linux_ (devcontainer on Apple ARM chips).
     Since the Docker container is running non-natively, we sacrifice a little bit of performance
     for a clean virtualization setup. For those running on x86/64, you can safely remove this flag.

     ```dockerfile
     FROM --platform=linux/amd64 debian:bullseye-slim
     ```

   - _anza_ is the current active maintainer of the Solana Validator (previously maintained by
     _Solana Labs_ team).

1. Build and run the devcontainer (approx. ~2.2 GB image).
1. Let's Start making a _fake_ Solana token!

> [!NOTE]
> While it's not strictly necessary to use a Docker and/or devcontainer, I prefer to keep my
> machine environment clean and separated among various different projects.

## Creating a Solana Token

1. First, we need an account/wallet/address/keypair that will own the token we're creating:

   1. Generate a new random account:

      ```sh
      solana-keygen new
      ```

   1. -or- Vanity account example:

      ```sh
      solana-keygen grind --starts-with abc:1
      ```

   1. -or- Recover your account via BIP39 words seed phrase:

      ```sh
      solana-keygen recover
      ```

   Several notes to consider:

   - Verify config:

     ```sh
     solana config get
     ```

   - If generated vanity keypair, ensure that this newly generated keypair is set as the default.

     Example:

     ```sh
     solana config set --keypair abc0123456789abcdefghijklmnopqrstuvwxyz.json
     ```

   - Ensure that you're on the correct Solana cluster (e.g. devnet):

     ```sh
     solana config set --url devnet
     ```

     fyi, other known clusters:

     ```sh
     solana config set --url mainnet-beta
     solana config set --url devnet
     solana config set --url localhost
     solana config set --url testnet
     ```

2. Lastly, `spl-token create-token`

## Get Some SOLs

> [!IMPORTANT]
> Any actions on the Solana blockchain will require fee/payment using its native currency SOL.

- Check the account's current balance using the `solana balance` command.
- Obtain free SOLs (devnet only) via:
  1. `solana airdrop 1` command (to get airdropped 1 SOL).
  1. -or- [Solana Devnet Faucet](https://faucet.solana.com/).

## Useful Commands

| Command                                                | Description                                     |
|--------------------------------------------------------|-------------------------------------------------|
| `solana config get`                                    | get the current configuration.                  |
| `solana config set --keypair ${HOME}/new-keypair.json` | set the default keypair.                        |
| `solana address`                                       | get the public key pair.                        |
| `solana balance`                                       | check the current SOL balance for this account. |
| `solana airdrop`                                       | request SOL from a faucet.                      |

## References

- [Solana docs](https://solana.com/docs/intro/installation)
- [anza docs](https://docs.anza.xyz/cli/intro)
- [Solana devnet explorer](https://explorer.solana.com/?cluster=devnet)

[^1]: NFT Craze and DeFi boom on [12 May 2021](https://ycharts.com/indicators/ethereum_average_gas_price)
[^2]: As of release [v2.2.4](https://github.com/anza-xyz/agave/releases/tag/v2.2.4) (2025-03-29).
