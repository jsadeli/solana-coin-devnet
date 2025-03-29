# Solana Token

Let's make a [Solana](https://solana.com) cryptocurrency token.

- Why? Because it's fun!
- Why Solana? Because it's a very fast and cheap blockchain network, also it runs on Rust
  (instead of Ethereum's Javascript-inspired Solidity).
  - Ethereum, one of the most popular blockchain, transactions typically take anywhere from 15s to 5min,
    with a gas fee that historically reached 2,000 gwei (~$200)[^1] in 2021.
  - As a comparison, Solana's transactions are typically completed in under 1s with fees of less than $0.01.

[^1]: NFT Craze and DeFi boom on [12 May 2021](https://ycharts.com/indicators/ethereum_average_gas_price)

## Getting Started

There are no-code web apps that can help you with making this token, but we are going to use the
Solana CLI instead (because we can).

1. Use the pre-configured [Dockerfile](Dockerfile) to run a [devcontainer](.devcontainer/devcontainer.json).

   - Setup the latest stable versions of Rust and Solana CLI.
   - For purposes of using devcontainer on Apple ARM chips, we need the `--platform=linux/amd64` flag
     because the Solana CLI does not support[^2] _aarch64 linux_ (devcontainer on Apple ARM chips).
     Since the Docker container is running non-natively, we sacrifice a little bit of performance
     for a clean virtualization setup. For those running on x86/64, you can safely remove this flag.

     ```dockerfile
     FROM --platform=linux/amd64 debian:bullseye-slim
     ```

2. Build and run the devcontainer (approx. ~2.2 GB image).
3. Let's start making a _fake_ Solana token!

> [!TIP]
> While it's not strictly necessary to use a Docker and/or devcontainer, I prefer to keep my
> machine environment clean and separated among various different projects.

[^2]: As of release [v2.2.4](https://github.com/anza-xyz/agave/releases/tag/v2.2.4) (2025-03-29).

## Creating a Wallet

First, we need an account/wallet/address/keypair that will own the token we're creating:

1. Generate a new random account:

   ```sh
   solana-keygen new
   ```

1. -or- Vanity account example:

   ```sh
   solana-keygen grind --starts-with cap:1
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
  solana config set --keypair caph7MHe2AJzBGDd3voEgvCBrqrqBJ7oCo9Tm1B2NcU.json
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

## Get Some SOLs

- Check the account's current balance using the `solana balance` command.
- Obtain free SOLs (devnet only) via:
  1. `solana airdrop 1` CLI command (to get airdropped 1 SOL).
  1. -or- [Solana Devnet Faucet](https://faucet.solana.com/).

> [!IMPORTANT]
> Any actions on the Solana blockchain will require fee/payment using its native currency SOL.
> Luckily it is free in _devnet_ (unlike in _mainnet_/production).

## Creating a Solana Token

1. Use the following command to create a new token ([_mint account_](https://solana.com/docs/core/tokens#mint-account))
   **with customizable metadata** (such as name, symbol, link to image):

   ```sh
   spl-token create-token --program-2022 --enable-metadata --decimals 9
   ```

   Example output:

   ```text
   Creating token ErSnKo6TESqDQSTVY4NNzayLsKVc3Xj1WjwB1n3KTpni under program TokenzQdBNbLqP5VEhdkAS6EPFLC1PHnBqCXEpPxuEb
   To initialize metadata inside the mint, please run `spl-token initialize-metadata ErSnKo6TESqDQSTVY4NNzayLsKVc3Xj1WjwB1n3KTpni <YOUR_TOKEN_NAME> <YOUR_TOKEN_SYMBOL> <YOUR_TOKEN_URI>`, and sign with the mint authority.

   Address:  ErSnKo6TESqDQSTVY4NNzayLsKVc3Xj1WjwB1n3KTpni
   Decimals:  9

   Signature: 5jwaf6zqzBEtuREkJc5Fd53QpRMf6ixtVMW6td3wArFA15u1VP2cTpbHJo1kLRx8tSHAgLzM4tqvbigem2q91Toz
   ```

   You can now use the [Solana Explorer](https://explorer.solana.com/?cluster=devnet) to inspect
   by specifying the address (e.g. `ErSnKo6TESqDQSTVY4NNzayLsKVc3Xj1WjwB1n3KTpni`).

1. Let's add some customizations to our new token:
   - Think of a name, symbol, description, and the image/logo for the token.
     - Try to keep the symbol as short as possible (e.g. 3–4 uppercase characters).
     - Custom square image of 512x512 that is less than 100 KB (e.g. use MS-Paint or AI).
   - Upload to a publicly accessible cloud storage (e.g. [Pinata](https://pinata.cloud/)).
   - Create a metadata JSON file; an example of the JSON format [here](https://raw.githubusercontent.com/solana-developers/opos-asset/main/assets/DeveloperPortal/metadata.json).

1. Apply those customizations (metadata) to the new token on the blockchain:

   ```sh
   spl-token initialize-metadata <TOKEN_MINT_ADDRESS> <YOUR_TOKEN_NAME> <YOUR_TOKEN_SYMBOL> <YOUR_TOKEN_URI>
   ```

   Example:

   ```sh
   spl-token initialize-metadata ErSnKo6TESqDQSTVY4NNzayLsKVc3Xj1WjwB1n3KTpni "Happy Seal" "HAPPYSEAL" "https://silver-obvious-gerbil-977.mypinata.cloud/ipfs/bafkreifmum6w4d3rij72iti2pp5ozd4aq6mg6lydloia3ahnwry4dsniky"
   ```

   The token URI is normally a link to offchain metadata you want to associate with the token.

1. To hold units of a particular token, you must create a [token account](https://solana.com/vi/docs/core/tokens#token-account).
   A token account is required for a user to hold tokens. A user will have at least one token account
   for every type of token they own.

   ```sh
   spl-token create-account [OPTIONS] <TOKEN_ADDRESS>
   ```

   Example:

   ```sh
   spl-token create-account ErSnKo6TESqDQSTVY4NNzayLsKVc3Xj1WjwB1n3KTpni
   ```

> [!NOTE]
> A Mint Account represents a specific type of token and stores global metadata about the token such
> as the total supply and mint authority (address authorized to create new units of a token).
>
> A Token Account keeps track of individual ownership of how many units of a specific type of token
> (mint account) are owned by a specific address.

## Let's Print Some Money~

1. Create new units of token (aka _minting_ or _printing money_) via the following CLI command:

   ```sh
   spl-token mint [OPTIONS] <TOKEN_ADDRESS> <TOKEN_AMOUNT> [--] [RECIPIENT_TOKEN_ACCOUNT_ADDRESS]
   ```

   Example:

   ```sh
   spl-token mint ErSnKo6TESqDQSTVY4NNzayLsKVc3Xj1WjwB1n3KTpni 1000
   ```

1. Verify the newly minted (_printed money_) tokens via:

   1. CLI example:

      ```sh
      spl-token supply 3fpcuwwkK9cLXktPuZUnikqDmSjZ9NVsPfsEDeegWjAY
      ```

   1. [Solana Explorer](https://explorer.solana.com/?cluster=devnet)

## Send and Receive

You can now send or receive this token on the blockchain.

1. Use a hot wallet app for a better UX (e.g. [Phantom](https://phantom.com)).

   For Phantom wallet, go to `Settings` >> `Developer Settings` >> Enable `Testnet Mode`.

1. -or- use the CLI command:

   ```sh
   spl-token transfer <TOKEN_MINT_ADDRESS> <TOKEN_AMOUNT> <RECIPIENT_WALLET_ADDRESS or RECIPIENT_TOKEN_ACCOUNT_ADDRESS>
   ```

## Mainnet

It is recommended to disable _mint_ and _freeze_ features for a _real_ token.

## Useful Commands Overview

| Command                                                                                                     | Description                                             |
|-------------------------------------------------------------------------------------------------------------|---------------------------------------------------------|
| `solana-keygen <SUBCOMMAND>`                                                                                | Solana key generation utility.                          |
| `solana config get [CONFIG_FIELD]`                                                                          | Get current config settings.                            |
| `solana config set --keypair ${HOME}/new-keypair.json`                                                      | Set a config setting.                                   |
| `solana address`                                                                                            | Get your public key.                                    |
| `solana balance [ACCOUNT_ADDRESS]`                                                                          | Get your balance.                                       |
| `solana airdrop <AMOUNT> [RECIPIENT_ADDRESS]`                                                               | Request SOL from a faucet.                              |
| `spl-token create-token [OPTIONS] [--] [TOKEN_KEYPAIR]`                                                     | Create a new token.                                     |
| `spl-token initialize-metadata <TOKEN_MINT_ADDRESS> <YOUR_TOKEN_NAME> <YOUR_TOKEN_SYMBOL> <YOUR_TOKEN_URI>` | Initialize metadata extension on a token mint.          |
| `spl-token update-metadata [OPTIONS] <TOKEN_MINT_ADDRESS> <FIELD_NAME> [VALUE_STRING]`                      | Update metadata on a token mint that has the extension. |
| `spl-token create-account [OPTIONS] <TOKEN_MINT_ADDRESS> [ACCOUNT_KEYPAIR]`                                 | Create a new token account.                             |
| `spl-token mint <TOKEN_ADDRESS> <TOKEN_AMOUNT> [--] [RECIPIENT_TOKEN_ACCOUNT_ADDRESS]`                      | Mint new tokens.                                        |
| `spl-token supply <TOKEN_MINT_ADDRESS>`                                                                     | Get token supply.                                       |
| `spl-token burn <TOKEN_ACCOUNT_ADDRESS> <TOKEN_AMOUNT>`                                                     | Burn tokens from an account.                            |

## References

- [Solana Docs](https://solana.com/docs/intro/installation)
  - [Core Concepts: Accounts](https://solana.com/docs/core/accounts)
  - [Core Concepts: Tokens](https://solana.com/docs/core/tokens)
- [anza Docs](https://docs.anza.xyz/cli/intro)
- [Solana Explorer](https://explorer.solana.com)
- [Solana Playground](https://beta.solpg.io/)
- [create your own Solana Token...in the terminal (2025 edition)](https://youtu.be/L4ASwqLZVV0?si=-h4-SkLUO_hvZwmq)
- [Create a Solana Token, NetworkChuck](https://blog.networkchuck.com/posts/create-a-solana-token/)
- [sol4k: a Kotlin client for Solana](https://sol4k.org/)
