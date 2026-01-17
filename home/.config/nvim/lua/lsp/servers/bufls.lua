-- buf LSP for Protocol Buffers
-- Install: go install github.com/bufbuild/buf-language-server/cmd/bufls@latest
return {
  cmd = { 'bufls', 'serve' },
  filetypes = { 'proto' },
  root_markers = { 'buf.yaml', 'buf.work.yaml', '.git' },

  settings = {},
}
