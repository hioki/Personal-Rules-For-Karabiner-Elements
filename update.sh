#!/bin/bash

CONFIG_DIR="$HOME/.config/karabiner"
SRC_FILE="./personal_rules.rb"
DST_FILE="./personal_rules.json"

if ! type jq >/dev/null 2>&1; then
  echo "jq command is required." 1>&2
  exit 1
fi

if [ ! -d ${CONFIG_DIR} ]; then
  echo "Create directory ${CONFIG_DIR} by operating Karabiner-Elements with GUI" 1>&2
  exit 2
fi

ruby $SRC_FILE | jq . > $DST_FILE && cp $DST_FILE "${CONFIG_DIR}/assets/complex_modifications/"

TARGET="${CONFIG_DIR}/karabiner.json"
QUERY=".profiles[0].complex_modifications.rules = $(jq '.rules' $DST_FILE)"

cat <<< "$(jq "$QUERY" < $TARGET)" > $TARGET
