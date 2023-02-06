# NFT Based Certifying and Rewarding Contract

# Usage

This contract is used for registering a delegation certificate and withdrawing staking rewards. Unlike the typical registration and rewarding transactions, instead of requiring a signing key, the transactions require a specific NFT to spent in the transaction.

The redeemer for the transactions can be any value because it is ignored by the smart contract.

# Assets

The compiled Plutus script is checked in to the following location: `assets/swap.plutus`

Address can be found as followed:
- Local testnet: `assets/local-testnet/swap.addr`
- Shared testnet: `assets/testnet/swap.addr`
- Mainnet: `assets/mainnet/swap.addr`

# Compiling

Compliation has been validated with GHC 8.10.7.

To compile call the compile script:

```bash
./scripts/compile.sh
```

The NFT that is used for unlocking is configured in the compile script and passed to the smart contract creation app `create-sc`, with the following parameters:

```bash
--nft-policy-id=POLICY_ID
--nft-token-name=TOKEN_NAME_ASCII
```

# Example Transaction

Example transactions are provided in the folder `scripts/happy-path`.

### ⚠️ Warning
Running the example transactions requires `cardano-cli-balance-fixer` which can installed from this repo: https://github.com/Canonical-LLC/cardano-cli-balance-fixer

First, create the protocol params file with:

```bash
./scripts/query-protocol-parameters.sh
```

To use the transactions, first test datums and wallets must be created.

## Test Wallet Creation

Run:

```bash
./scripts/wallets/make-all-wallets.sh
```

## Environment Variable Setup

To setup the proper flags and socket variables for the test transactions, one must source the appropiate environment variables.

### ⚠️ Warning
To use the local testnet envars, the file must be modified to point to your local testnet location.

- Local testnet: `source scripts/envars/local-testnet.envars`
- Shared testnet: `source scripts/envars/testnet-env.envars`
- Mainnet: `source scripts/envars/mainnet-env.envars`

Now, one can run the `scripts/happy-path/` transactions.

# Testing

### ⚠️ Prerequistes
**Follow all the setup steps in the `Example Transaction` section, before continuing.**

There is a single test script, which performs a number of integration tests functions.

To execute the integration test, run:

```bash
./scripts/tests/register-and-withdraw.sh
```
