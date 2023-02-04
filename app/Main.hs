{-# OPTIONS_GHC -fno-warn-orphans #-}

module Main where
import           Cardano.Api
import           Canonical.Reward
import           Plutus.V1.Ledger.Value
import           Options.Generic
import           Data.String

instance ParseField TokenName where
  parseField x y z w = fromString <$> parseField x y z w
  readField = fromString <$> readField

instance ParseFields TokenName where
  parseFields x y z w = fromString <$> parseFields x y z w

instance ParseRecord TokenName where
  parseRecord = fromString <$> parseRecord

instance ParseField CurrencySymbol where
  parseField x y z w = fromString <$> parseField x y z w
  readField = fromString <$> readField

instance ParseFields CurrencySymbol where
  parseFields x y z w = fromString <$> parseFields x y z w

instance ParseRecord CurrencySymbol where
  parseRecord = fromString <$> parseRecord

data Options = Options
  { outputFile    :: FilePath
  , nftPolicyId   :: CurrencySymbol
  , nftTokenName  :: TokenName
  }
  deriving(Generic)

fieldModifier :: Modifiers
fieldModifier = lispCaseModifiers
  { fieldNameModifier = fieldNameModifier lispCaseModifiers
  }

instance ParseRecord Options where
  parseRecord = parseRecordWithModifiers fieldModifier

main :: IO ()
main = run =<< getRecord "NFT Update Compiler"

run :: Options -> IO ()
run Options {..} = do

  let
    cfg = RewardConfig
      { rcNftPolicyId  = nftPolicyId
      , rcNftTokenName = nftTokenName
      }

  result <- writeFileTextEnvelope outputFile Nothing (reward cfg)
  case result of
    Left err -> print $ displayError err
    Right () -> putStrLn $ "wrote validator to file " ++ outputFile
