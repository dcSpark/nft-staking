set -eux

mkdir -p temp

address=$1
signinKey=$2
policyScript=$3
policyId=$4
tokenName=$5
mintCount=$6


cardano-cli transaction build \
  --babbage-era \
  $BLOCKCHAIN \
  --tx-in  $(cardano-cli-balance-fixer collateral --address $address $BLOCKCHAIN) \
  --tx-in-collateral $(cardano-cli-balance-fixer collateral --address $address $BLOCKCHAIN) \
  --tx-out "$address + 1758582 lovelace + $mintCount $policyId.$tokenName" \
  --mint="$mintCount $policyId.$tokenName" \
  --minting-script-file $policyScript \
  --mint-redeemer-value [] \
  --change-address $address \
  --protocol-params-file scripts/$BLOCKCHAIN_PREFIX/protocol-parameters.json \
  --out-file temp/mint_tx.body

cardano-cli transaction sign  \
  --signing-key-file $signinKey \
  $BLOCKCHAIN \
  --tx-body-file temp/mint_tx.body \
  --out-file temp/mint_tx.signed

cardano-cli transaction submit --tx-file temp/mint_tx.signed $BLOCKCHAIN
