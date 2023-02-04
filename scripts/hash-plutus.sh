#!/usr/bin/env bash

set -eu

thisDir=$(dirname "$0")
mainDir=$thisDir/..
assetDir=$mainDir/assets
mkdir -p $assetDir/mainnet
mkdir -p $assetDir/testnet
mkdir -p $assetDir/local-testnet

$thisDir/staking/create-certificate.sh
$thisDir/staking/create-delegation-certificate.sh

cardano-cli address build \
  --payment-script-file $assetDir/reward.plutus \
  --mainnet \
  --out-file $assetDir/mainnet/reward-payment.addr

cardano-cli stake-address build \
  --stake-script-file $assetDir/reward.plutus \
  --mainnet \
  --out-file $assetDir/mainnet/reward-staking.addr

cardano-cli address build \
  --payment-script-file $assetDir/reward.plutus \
  --testnet-magic 1097911063 \
  --out-file $assetDir/testnet/reward.addr

cardano-cli stake-address build \
  --stake-script-file $assetDir/reward.plutus \
  --testnet-magic 1097911063 \
  --out-file $assetDir/testnet/reward-staking.addr

cardano-cli address build \
  --payment-script-file $assetDir/reward.plutus \
  --testnet-magic 42 \
  --out-file $assetDir/local-testnet/reward.addr

cardano-cli stake-address build \
  --stake-script-file $assetDir/reward.plutus \
  --testnet-magic 42 \
  --out-file $assetDir/local-testnet/reward-staking.addr
