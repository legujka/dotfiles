-- YAML language server
-- Configured for docker-compose, Taskfile, golangci-lint
return {
  cmd = { 'yaml-language-server', '--stdio' },
  filetypes = { 'yaml', 'yml', 'yaml.docker-compose' },
  root_markers = { 'docker-compose.yml', 'docker-compose.yaml', 'Taskfile.yml', '.git' },

  settings = {
    yaml = {
      -- Schema mappings for common files
      schemas = {
        -- Docker Compose
        ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = {
          "docker-compose*.yml",
          "docker-compose*.yaml",
          "compose*.yml",
          "compose*.yaml",
        },
        -- Taskfile
        ["https://taskfile.dev/schema.json"] = {
          "Taskfile*.yml",
          "Taskfile*.yaml",
        },
        -- golangci-lint
        ["https://golangci-lint.run/jsonschema/golangci.jsonschema.json"] = {
          ".golangci*.yml",
          ".golangci*.yaml",
        },
        -- GitHub Actions
        ["https://json.schemastore.org/github-workflow.json"] = {
          ".github/workflows/*.yml",
          ".github/workflows/*.yaml",
        },
      },

      -- Validation
      validate = true,
      hover = true,
      completion = true,

      -- Format
      format = {
        enable = true,
        singleQuote = false,
        bracketSpacing = true,
      },

      -- Custom tags (for docker-compose, etc)
      customTags = {
        "!reference sequence",
        "!secret scalar",
        "!vault scalar",
      },
    },
  },
}
