userAddr=$1
signingKey=$2
tokenName=$3

./scripts/minting/test-mint-tx.sh \
  $userAddr \
  $signingKey \
   scripts/test-policies/test-policy-1.plutus \
   $(cat scripts/test-policies/test-policy-1-id.txt) \
   $tokenName \
   1
