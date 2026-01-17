---@module "rishav.lsp"
---LSP keymaps and configuration
---
--- LSP keybindings follow conventions:
--- g prefix - Go to (definition, references, etc.)
--- K - Hover documentation
--- <leader>l prefix - LSP actions (format, rename, etc.)
--- <leader>c prefix - Code actions
local utils = require("rishav.core.utils")
local icons = require("rishav.core.icons")

local map = utils.map

---Setup LSP keymaps for a buffer
---@param client vim.lsp.Client
---@param bufnr integer
local function setup_keymaps(client, bufnr)
    local opts = { buffer = bufnr }

    -- Navigation (g prefix for "go to")
    map("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
    map("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "Go to declaration" }))
    map("n", "gr", "<cmd>Telescope lsp_references<CR>", vim.tbl_extend("force", opts, { desc = "Go to references" }))
    map("n", "gi", "<cmd>Telescope lsp_implementations<CR>", vim.tbl_extend("force", opts, { desc = "Go to implementations" }))
    map("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", vim.tbl_extend("force", opts, { desc = "Go to type definition" }))

    -- Documentation
    map("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover documentation" }))
    map("n", "gK", vim.lsp.buf.signature_help, vim.tbl_extend("force", opts, { desc = "Signature help" }))
    map("i", "<C-k>", vim.lsp.buf.signature_help, vim.tbl_extend("force", opts, { desc = "Signature help" }))

    -- Code actions (leader + c)
    map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code action" }))
    map("n", "<leader>cs", "<cmd>Telescope lsp_document_symbols<CR>", vim.tbl_extend("force", opts, { desc = "Document symbols" }))
    map("n", "<leader>cS", "<cmd>Telescope lsp_workspace_symbols<CR>", vim.tbl_extend("force", opts, { desc = "Workspace symbols" }))

    -- LSP management (leader + l)
    map("n", "<leader>lr", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename symbol" }))
    map("n", "<leader>lf", function()
        vim.lsp.buf.format({ async = true })
    end, vim.tbl_extend("force", opts, { desc = "Format document" }))
    map("v", "<leader>lf", function()
        vim.lsp.buf.format({ async = true })
    end, vim.tbl_extend("force", opts, { desc = "Format selection" }))
    map("n", "<leader>li", "<cmd>LspInfo<CR>", vim.tbl_extend("force", opts, { desc = "LSP info" }))
    map("n", "<leader>lR", "<cmd>LspRestart<CR>", vim.tbl_extend("force", opts, { desc = "Restart LSP" }))

    -- Inlay hints toggle (if supported)
    if client:supports_method("textDocument/inlayHint", bufnr) then
        map("n", "<leader>lh", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }))
        end, vim.tbl_extend("force", opts, { desc = "Toggle inlay hints" }))
    end

    -- Codelens (if supported)
    if client:supports_method("textDocument/codeLens", bufnr) then
        map("n", "<leader>ll", vim.lsp.codelens.run, vim.tbl_extend("force", opts, { desc = "Run codelens" }))
        map("n", "<leader>lL", vim.lsp.codelens.refresh, vim.tbl_extend("force", opts, { desc = "Refresh codelens" }))
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

-- Configure floating windows with rounded borders (Neovim 0.11+)
-- Uses the new 'winborder' option instead of deprecated vim.lsp.with()
vim.o.winborder = "rounded"
