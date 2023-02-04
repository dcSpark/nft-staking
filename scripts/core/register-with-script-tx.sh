#!/usr/bin/env bash

set -eux

thisDir=$(dirname "$0")
baseDir=$thisDir/../
tempDir=$baseDir/../temp
assetDir=$baseDir/../assets

mkdir -p $tempDir

signingAddress=$1
signingKey=$2
scriptFile="$assetDir/reward.plutus"

# --witness-override 3 \

changeOutput=$(cardano-cli-balance-fixer change --address $signingAddress $BLOCKCHAIN)

extraOutput=""
if [ "$changeOutput" != "" ];then
  extraOutput="+ $changeOutput"
fi


cardano-cli transaction build \
  --babbage-era \
    $BLOCKCHAIN \
    $(cardano-cli-balance-fixer input --address $signingAddress $BLOCKCHAIN) \
  --tx-in-collateral $(cardano-cli-balance-fixer collateral --address $signingAddress $BLOCKCHAIN) \
  --tx-out "$signingAddress + 3000000 $extraOutput" \
  --change-address "$signingAddress" \
  --certificate-file "$tempDir/script.delegcert" \
  --certificate-script-file "$scriptFile" \
  --certificate-redeemer-value '42' \
  --protocol-params-file scripts/$BLOCKCHAIN_PREFIX/protocol-parameters.json \
  --out-file "$tempDir/script-delegation-cert.txbody"

cardano-cli transaction sign \
  --tx-body-file "$tempDir/script-delegation-cert.txbody" \
  $BLOCKCHAIN \
  --signing-key-file "$signingKey" \
  --out-file "$tempDir/script-delegation-cert.tx"

echo "Submitting staking script delegation certificate..."

cardano-cli transaction submit \
  --tx-file "$tempDir/script-delegation-cert.tx" \
  $BLOCKCHAIN
