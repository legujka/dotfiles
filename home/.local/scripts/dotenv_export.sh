#!/bin/bash

# Usage: source ./dotenv_export.sh

ENV_FILE="${ENV_FILE:-.env}"

if [[ ! -f "$ENV_FILE" ]]; then
  echo "Error: ENV file '$ENV_FILE' not found" >&2
  return 1
fi

while IFS='=' read -r key value; do
  [[ -z "$key" || "$key" =~ ^[[:space:]]*# ]] && continue
  
  key="${key#export }"
  key="${key//[[:space:]]/}"
  
  value="${value#\"}"
  value="${value%\"}"
  value="${value#\'}"
  value="${value%\'}"
  
  export "$key=$value"
done < "$ENV_FILE"

echo "Environment loaded from $ENV_FILE" >&2
