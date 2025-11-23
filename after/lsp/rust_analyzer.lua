return {
  on_attach = function(client, bufnr)
    if client.server_capabilities.inlayHintProvider then
      vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    end
  end,
  -- cmd = {
  --   "rustup",
  --   "run",
  --   "stable",
  --   "rust-analyzer",
  -- },
  settings = {
    ["rust-analyzer"] = {
      -- cargo = {
      --   allFeatures = true,
      -- },
      checkOnSave = {
        command = "clippy",
      },
      procMacro = {
        enable = true, -- UNCOMMENT THIS - needed for macro expansion
      },
      check = {
        command = "clippy", -- UNCOMMENT THIS - enables real-time checks
      },
      --   diagnostics = {
      --     enable = true, -- UNCOMMENT THIS - enables diagnostics
      --     disabled = { "unresolved-proc-macro" }, -- optional, keeps this if you want
      --     experimental = {
      --       enable = true,
      --     },
      --   },
    },
  },
}
