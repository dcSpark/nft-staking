set -eu
thisDir=$(dirname "$0")
baseDir=$thisDir/..
mainDir=$baseDir/..
tempDir=$mainDir/temp
assetDir=$mainDir/assets

cardano-cli stake-address delegation-certificate \
  --stake-script-file "$assetDir/reward.plutus" \
  --cold-verification-key-file "$POOL_KEY" \
  --out-file "$tempDir/script.delegcert"
