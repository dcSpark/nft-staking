#!/usr/bin/env bash

set -eux

thisDir=$(dirname "$0")
baseDir=$thisDir/../
tempDir=$baseDir/../temp
assetDir=$baseDir/../assets

mkdir -p $tempDir

signingAddress=$1
signingKey=$2

# --witness-override 3 \
#   --tx-out "$signingAddress + $lovelaceattxin2div3" \

changeOutput=$(cardano-cli-balance-fixer change --address $signingAddress $BLOCKCHAIN)

extraOutput=""
if [ "$changeOutput" != "" ];then
  extraOutput="+ $changeOutput"
fi

cardano-cli transaction build \
  --babbage-era \
    $BLOCKCHAIN \
    $(cardano-cli-balance-fixer input --address $signingAddress $BLOCKCHAIN) \
  --tx-out "$signingAddress + 3000000 $extraOutput" \
  --change-address "$signingAddress" \
  --certificate-file "$tempDir/script.regcert" \
  --out-file "$tempDir/script-registration-cert.txbody"

cardano-cli transaction sign \
  --tx-body-file "$tempDir/script-registration-cert.txbody" \
    $BLOCKCHAIN \
  --signing-key-file "$signingKey" \
  --out-file "$tempDir/script-registration-cert.tx"

cardano-cli transaction submit \
  --tx-file "$tempDir/script-registration-cert.tx" \
    $BLOCKCHAIN
