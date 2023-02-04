{-# LANGUAGE NoImplicitPrelude #-}

module Canonical.Reward where

import           Cardano.Api.Shelley (PlutusScript (..), PlutusScriptV2)
import           Codec.Serialise
import qualified Data.ByteString.Lazy as LB
import qualified Data.ByteString.Short as SBS
import           Plutus.V1.Ledger.Value
import           Plutus.V2.Ledger.Contexts
import           Plutus.V1.Ledger.Scripts
import           PlutusTx
import           PlutusTx.Prelude hiding (Semigroup (..), unless)

data RewardConfig = RewardConfig
  { rcNftPolicyId  :: CurrencySymbol
  , rcNftTokenName :: TokenName
  }

type Action = BuiltinData

makeLift ''RewardConfig

mkValidator :: RewardConfig -> Action -> ScriptContext -> Bool
mkValidator
  RewardConfig{..}
  _
  ScriptContext{ scriptContextTxInfo = TxInfo{..}
               , scriptContextPurpose } =
    let
      -- Make sure the nft is being spent
      nftSpent :: Bool
      nftSpent = any (\TxInInfo {txInInfoResolved = TxOut {..}} ->
        valueOf txOutValue rcNftPolicyId rcNftTokenName > 0) txInfoInputs

      -- Make sure the script purpose is either Rewarding or Certifying
      purposeIsRewardingOrCertifying :: Bool
      purposeIsRewardingOrCertifying = case scriptContextPurpose of
        Certifying {} -> True
        Rewarding  {} -> True
        _             -> False

    in traceIfFalse "NFT is not spent" nftSpent
    && traceIfFalse "Wrong script purpose" purposeIsRewardingOrCertifying
-------------------------------------------------------------------------------
-- Boilerplate
-------------------------------------------------------------------------------
wrapValidator
    :: RewardConfig
    -> BuiltinData
    -> BuiltinData
    -> ()
wrapValidator cfg a b
  = check (mkValidator cfg (unsafeFromBuiltinData a) (unsafeFromBuiltinData b))

validator :: RewardConfig -> StakeValidator
validator cfg = mkStakeValidatorScript $
    $$(compile [|| wrapValidator ||])
    `applyCode`
      liftCode cfg

-------------------------------------------------------------------------------
-- Entry point
-------------------------------------------------------------------------------
reward :: RewardConfig -> PlutusScript PlutusScriptV2
reward
  = PlutusScriptSerialised
  . SBS.toShort
  . LB.toStrict
  . serialise
  . validator
