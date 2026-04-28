return {
    -- NOTE: Avoid `init_options` for rust-analyzer.
    -- nvim-lspconfig auto-populates initializationOptions from `settings["rust-analyzer"]`.
    settings = {
        ["rust-analyzer"] = {
            cargo = {
                -- Modern equivalent of the old `cargo.allFeatures = true`.
                features = "all",
                buildScripts = {
                    enable = true,
                },
            },
            procMacro = {
                enable = true,
            },
            checkOnSave = true,
            check = {
                command = "clippy",
            },
            diagnostics = {
                enable = true,
            },
        },
    },
}
