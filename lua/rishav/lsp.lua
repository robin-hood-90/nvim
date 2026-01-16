---@module "rishav.lsp"
---LSP keymaps and configuration
local utils = require("rishav.core.utils")
local icons = require("rishav.core.icons")

local map = utils.map

---Setup LSP keymaps for a buffer
---@param client vim.lsp.Client
---@param bufnr integer
local function setup_keymaps(client, bufnr)
    local opts = { buffer = bufnr }

    -- Navigation
    map("n", "gR", "<cmd>Telescope lsp_references<CR>", vim.tbl_extend("force", opts, { desc = "LSP references" }))
    map("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "Go to declaration" }))
    map("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
    map("n", "gi", "<cmd>Telescope lsp_implementations<CR>", vim.tbl_extend("force", opts, { desc = "LSP implementations" }))
    map("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", vim.tbl_extend("force", opts, { desc = "LSP type definitions" }))

    -- Actions
    map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code action" }))
    map("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Smart rename" }))

    -- Diagnostics
    map("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", vim.tbl_extend("force", opts, { desc = "Buffer diagnostics" }))
    map("n", "<leader>d", vim.diagnostic.open_float, vim.tbl_extend("force", opts, { desc = "Line diagnostics" }))

    -- Documentation
    map("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover documentation" }))
    map("i", "<C-k>", vim.lsp.buf.signature_help, vim.tbl_extend("force", opts, { desc = "Signature help" }))

    -- Utility
    map("n", "<leader>rs", "<cmd>LspRestart<CR>", vim.tbl_extend("force", opts, { desc = "Restart LSP" }))

    -- Inlay hints toggle (if supported)
    if client:supports_method("textDocument/inlayHint", bufnr) then
        map("n", "<leader>ih", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }))
        end, vim.tbl_extend("force", opts, { desc = "Toggle inlay hints" }))
    end
end

---Setup LSP features for a buffer
---@param client vim.lsp.Client
---@param bufnr integer
local function on_attach(client, bufnr)
    -- Enable completion
    vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

    -- Setup keymaps
    setup_keymaps(client, bufnr)

    -- Document highlight on cursor hold (if supported)
    if client:supports_method("textDocument/documentHighlight", bufnr) then
        local highlight_augroup = vim.api.nvim_create_augroup("lsp_document_highlight_" .. bufnr, { clear = true })

        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            buffer = bufnr,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
        })

        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            buffer = bufnr,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
        })

        vim.api.nvim_create_autocmd("LspDetach", {
            buffer = bufnr,
            group = highlight_augroup,
            callback = function()
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds({ group = highlight_augroup })
            end,
        })
    end
end

-- LspAttach autocmd
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
    callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if client then
            on_attach(client, ev.buf)
        end
    end,
})

-- Enable inlay hints globally by default
vim.lsp.inlay_hint.enable(true)

-- Configure diagnostic signs using icons module
vim.diagnostic.config({
    signs = icons.get_diagnostic_signs(),
})

-- Configure floating windows with rounded borders
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
})

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "rounded",
})
