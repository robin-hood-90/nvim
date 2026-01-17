-- Only enable rust-analyzer if cargo is available
local cargo_available = vim.fn.executable("cargo") == 1

if not cargo_available then
    -- Return empty config to prevent rust-analyzer from starting
    -- This avoids errors when Rust toolchain is not installed
    return {
        autostart = false,
        root_dir = function()
            return nil
        end,
    }
end

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
