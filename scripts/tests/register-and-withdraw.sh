set -eu

thisDir=$(dirname "$0")
baseDir=$thisDir/../

# Mint the user and reference nfts
$baseDir/minting/mint-0-policy.sh $(cat ~/$BLOCKCHAIN_PREFIX/user0.addr) ~/$BLOCKCHAIN_PREFIX/user0.skey 30
$baseDir/wait/until-next-block.sh

$baseDir/happy-path/create-registration-cert-tx.sh
$baseDir/wait/until-next-block.sh

echo Missing NFT For Registration
detected=false

"$baseDir/failure-cases/register-with-script-no-nft-tx.sh" || {
    detected=true
}

if [ $detected == false ]; then
  echo "FAILED! Withdrew without an NFT!"
  exit 1
fi

$baseDir/happy-path/register-with-script-tx.sh
$baseDir/wait/until-next-block.sh

echo Missing NFT For Withdrawal
detected=false

"$baseDir/failure-cases/withdraw-no-nft-tx.sh" || {
    detected=true
}

if [ $detected == false ]; then
  echo "FAILED! Withdrew without an NFT!"
  exit 1
fi

$baseDir/happy-path/withdraw-tx.sh
$baseDir/wait/until-next-block.sh

echo "SUCCESS!"
