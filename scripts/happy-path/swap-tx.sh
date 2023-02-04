#!/usr/bin/env bash

set -eux

thisDir=$(dirname "$0")
baseDir=$thisDir/../
tempDir=$baseDir/../temp

DATUM_PREFIX=${DATUM_PREFIX:-0}

initialNft=ce8822885d18e7d304ef0248af49359d687a94f0e3635eea14c6154e.30
swappedNft=7038197ba9c25791cf7849d3727c812075f07d29cb4f049eab741400.30

$baseDir/core/swap-tx.sh \
  $(cat ~/$BLOCKCHAIN_PREFIX/user0.addr) \
  ~/$BLOCKCHAIN_PREFIX/user0.skey \
  $tempDir/$BLOCKCHAIN_PREFIX/datums/$DATUM_PREFIX/initial.json \
  $(cat $tempDir/$BLOCKCHAIN_PREFIX/datums/$DATUM_PREFIX/initial-hash.txt) \
  $tempDir/$BLOCKCHAIN_PREFIX/datums/$DATUM_PREFIX/swapped.json \
  "+ 1 $swappedNft" \
  $(cat ~/$BLOCKCHAIN_PREFIX/marketplace.addr) \
  "+ 1 $initialNft" \
  "1000000 lovelace"
