#!/usr/bin/env bash
set -eu

thisDir=$(dirname "$0")
baseDir=$thisDir/..
tempDir=$baseDir/../temp

DATUM_PREFIX=${DATUM_PREFIX:-0}

$baseDir/minting/mint-1-policy.sh \
  $(cat ~/$BLOCKCHAIN_PREFIX/user0.addr) \
  ~/$BLOCKCHAIN_PREFIX/user0.skey \
  "30"
