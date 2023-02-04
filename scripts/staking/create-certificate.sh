set -eu
thisDir=$(dirname "$0")
baseDir=$thisDir/..
mainDir=$baseDir/..
tempDir=$mainDir/temp
assetDir=$mainDir/assets

cardano-cli stake-address registration-certificate \
  --stake-script-file "$assetDir/reward.plutus" \
  --out-file "$tempDir/script.regcert"
