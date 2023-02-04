#!/usr/bin/env bash
set -eu

thisDir=$(dirname "$0")
baseDir=$thisDir/..
tempDir=$baseDir/../temp

DATUM_PREFIX=${DATUM_PREFIX:-0}

$baseDir/core/register-with-script-tx.sh \
  $(cat ~/$BLOCKCHAIN_PREFIX/user1.addr) \
  ~/$BLOCKCHAIN_PREFIX/user1.skey
