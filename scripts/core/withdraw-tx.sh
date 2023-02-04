#!/usr/bin/env bash

set -eux

thisDir=$(dirname "$0")
baseDir=$thisDir/../
tempDir=$baseDir/../temp
assetDir=$baseDir/../assets

signingAddress=$1
signingKey=$2
scriptFile="$assetDir/reward.plutus"
stakingscriptaddr=$(cat $assetDir/$BLOCKCHAIN_PREFIX/reward-staking.addr)


changeOutput=$(cardano-cli-balance-fixer change --address $signingAddress $BLOCKCHAIN)

extraOutput=""
if [ "$changeOutput" != "" ];then
  extraOutput="+ $changeOutput"
fi


cardano-cli query stake-address-info \
  --address "$stakingscriptaddr" \
  $BLOCKCHAIN \
  --out-file "$tempDir/scriptdelegationstatusrewards.json"

rewardamt=$(jq -r '.[0].rewardAccountBalance' $tempDir/scriptdelegationstatusrewards.json)

cardano-cli transaction build \
  --babbage-era \
  $BLOCKCHAIN \
  $(cardano-cli-balance-fixer input --address $signingAddress $BLOCKCHAIN) \
  --tx-in-collateral $(cardano-cli-balance-fixer collateral --address $signingAddress $BLOCKCHAIN) \
  --tx-out "$signingAddress + 3000000 $extraOutput" \
  --change-address "$signingAddress" \
  --withdrawal "$stakingscriptaddr+$rewardamt" \
  --withdrawal-script-file "$scriptFile" \
  --withdrawal-redeemer-value '42' \
  --protocol-params-file scripts/$BLOCKCHAIN_PREFIX/protocol-parameters.json \
  --out-file "$tempDir/script-withdrawal.txbody"

cardano-cli transaction sign \
  --tx-body-file "$tempDir/script-withdrawal.txbody" \
  $BLOCKCHAIN \
  --signing-key-file $signingKey \
  --out-file "$tempDir/script-withdrawal.tx"

cardano-cli transaction submit \
  --tx-file "$tempDir/script-withdrawal.tx" \
  $BLOCKCHAIN
