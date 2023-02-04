set -eu

thisDir=$(dirname "$0")
baseDir=$thisDir/..
assetDir=$baseDir/../assets

cardano-cli address key-gen \
  --verification-key-file ~/$BLOCKCHAIN_PREFIX/$1.vkey \
  --signing-key-file ~/$BLOCKCHAIN_PREFIX/$1.skey

cardano-cli address build \
  $BLOCKCHAIN \
  --payment-verification-key-file ~/$BLOCKCHAIN_PREFIX/$1.vkey \
  --stake-script-file $assetDir/reward.plutus \
  --out-file ~/$BLOCKCHAIN_PREFIX/$1.addr
