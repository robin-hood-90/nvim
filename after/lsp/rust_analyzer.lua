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
            cargo = {
                allFeatures = true,
                loadOutDirsFromCheck = true,
                buildScripts = {
                    enable = true,
                },
            },
            checkOnSave = true, -- Enable check on save (cargo check diagnostics)
            procMacro = {
                enable = true, -- Needed for macro expansion
            },
            check = {
                command = "clippy", -- Use clippy for checks
            },
            -- Enable native rust-analyzer diagnostics (real-time while typing)
            diagnostics = {
                enable = true,
                experimental = {
                    enable = true,
                },
            },
        },
    },
}
