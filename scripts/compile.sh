set -eu
thisDir=$(dirname "$0")
mainDir=$thisDir/..
tempDir=$mainDir/temp

(
cd $mainDir
cabal run create-sc -- \
  --output-file=assets/reward.plutus \
  --nft-policy-id=ce8822885d18e7d304ef0248af49359d687a94f0e3635eea14c6154e \
  --nft-token-name=0
)

$thisDir/hash-plutus.sh
