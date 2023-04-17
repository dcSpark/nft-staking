{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DataKinds #-}

module Canonical.Reward where

import           PlutusLedgerApi.V1.Value
import           PlutusLedgerApi.V2.Contexts
import           PlutusLedgerApi.Common
import           PlutusTx
import           PlutusTx.Prelude hiding (Semigroup (..), unless)

data RewardConfig = RewardConfig
  { rcNftPolicyId  :: CurrencySymbol
  , rcNftTokenName :: TokenName
  }

makeLift ''RewardConfig

type Action = BuiltinData

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

validator :: RewardConfig -> CompiledCode (BuiltinData -> BuiltinData -> ())
validator cfg =
    $$(compile [|| wrapValidator ||])
    `applyCode`
      liftCode cfg

-------------------------------------------------------------------------------
-- Entry point
-------------------------------------------------------------------------------
reward :: RewardConfig -> SerialisedScript
reward = serialiseCompiledCode . validator
