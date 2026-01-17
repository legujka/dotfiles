return {
  cmd = { 'gopls' },
  filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
  root_markers = { 'go.work', 'go.mod', '.git' },

  settings = {
    gopls = {
      directoryFilters = {
        "-**/node_modules",
        "-**/.git",
        "-**/vendor",
        "-**/tmp",
        "-**/testdata",
        "-**/.cache",
        "-**/dist",
        "-**/build",
      },

      -- Analysis settings
      analyses = {
        unusedparams = true,
        shadow = false,
        unusedwrite = false,
        fieldalignment = false,
        nilness = true,
        unusedvariable = true,
        useany = true,
      },

      -- Completion settings
      completeUnimported = true,
      usePlaceholders = false,
      matcher = "Fuzzy",
      completionBudget = "500ms",

      staticcheck = true,

      diagnosticsDelay = "500ms",

      codelenses = {
        gc_details = false,
        generate = false,
        regenerate_cgo = false,
        test = true,
        tidy = false,
        upgrade_dependency = false,
        vendor = false,
      },

      hints = {
        constantValues = true,
        parameterNames = true,
        assignVariableTypes = false,     -- Don't show ": type" for variables
        compositeLiteralFields = false,  -- Don't show field names in structs
        compositeLiteralTypes = false,   -- Don't show types in composite literals
        functionTypeParameters = false,  -- Don't show function type params
        rangeVariableTypes = false,      -- Don't show range variable types
      },

      semanticTokens = true,

      gofumpt = false, -- Set to true if you want stricter formatting (requires gofumpt installed)

      -- Symbol matching
      symbolMatcher = "FastFuzzy",
      symbolStyle = "Dynamic",

      -- Hover documentation
      linksInHover = true,
      linkTarget = "pkg.go.dev",

      -- Experimental features
      experimentalPostfixCompletions = true,

      -- Workspace control (helps reduce gopls workload)
      expandWorkspaceToModule = true, -- Experimental: determine workspace packages

      -- Template files
      templateExtensions = { "gotmpl", "tmpl" },

      -- Verbosity (for debugging)
      verboseOutput = false,

      -- Analysis progress reporting
      analysisProgressReporting = true, -- Show progress during indexing
    },
  },
}
