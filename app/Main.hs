{-# OPTIONS_GHC -fno-warn-orphans #-}
{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE OverloadedStrings #-}

module Main where
import           Canonical.Reward
import           PlutusLedgerApi.V1.Value
import           Options.Generic
import           Data.String
import qualified Data.ByteString.Short as SBS
import qualified Codec.CBOR.Encoding as CBOR
import qualified Codec.CBOR.Write as CBOR
import qualified Data.ByteString.Builder as BS

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

    hex =
      BS.byteStringHex
      $ CBOR.toStrictByteString
      $ CBOR.encodeBytes
      $ SBS.fromShort
      $ reward cfg

  BS.writeFile outputFile ("{\"type\":\"PlutusScriptV2\",\"description\":\"\",\"cborHex\":\"" <> hex <> "\"}")
