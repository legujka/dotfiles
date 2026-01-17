#!/bin/bash

set -e

TOOLS=(
  "github.com/go-delve/delve/cmd/dlv@v1.26.0"
  "github.com/bufbuild/buf/cmd/buf@v1.62.1"
  "github.com/vektra/mockery/v3@v3.6.1"
  "github.com/golangci/golangci-lint/v2/cmd/golangci-lint@v2.8.0"
  "github.com/jesseduffield/lazygit@latest"
  "golang.org/x/tools/gopls@latest"
)

for tool in "${TOOLS[@]}"; do
  echo "Installing $tool..."
  go install "$tool"
done
