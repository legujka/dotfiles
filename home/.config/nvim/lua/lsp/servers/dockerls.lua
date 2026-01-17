-- Docker language server
return {
  cmd = { 'docker-langserver', '--stdio' },
  filetypes = { 'dockerfile', 'Dockerfile' },
  root_markers = { 'Dockerfile', '.git' },

  settings = {},
}
