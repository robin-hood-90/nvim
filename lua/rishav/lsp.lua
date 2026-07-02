---@module "rishav.lsp"
---LSP keymaps and configuration (josean-dev style)
---
--- LSP keybindings follow conventions:
--- g prefix - Go to (definition, references, etc.)
--- K - Hover documentation
--- <leader>c prefix - Code actions (rename, code actions, LSP management)
local utils = require("rishav.core.utils")
local icons = require("rishav.core.icons")

local map = utils.map

---@param client vim.lsp.Client
---@param bufnr integer
local function setup_codelens(client, bufnr)
    if not client:supports_method("textDocument/codeLens", bufnr) then
        return
    end

    local function refresh_codelens()
        local filter = { bufnr = bufnr }
        if vim.lsp.codelens.is_enabled(filter) then
            vim.lsp.codelens.enable(false, filter)
        end
        vim.lsp.codelens.enable(true, filter)
    end

    refresh_codelens()

    local group = vim.api.nvim_create_augroup("lsp_codelens_" .. bufnr, { clear = true })
    vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave", "BufWritePost" }, {
        buffer = bufnr,
        group = group,
        callback = function()
            if vim.api.nvim_buf_is_valid(bufnr) then
                refresh_codelens()
            end
        end,
    })

    vim.api.nvim_create_autocmd("LspDetach", {
        buffer = bufnr,
        group = group,
        callback = function()
            vim.api.nvim_clear_autocmds({ group = group })
        end,
    })
end

---Setup LSP keymaps for a buffer
---@param client vim.lsp.Client
---@param bufnr integer
local function setup_keymaps(client, bufnr)
    local opts = { buffer = bufnr }

    -- Navigation (g prefix for "go to")
    map("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
    map("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "Go to declaration" }))
    map("n", "gR", "<cmd>Telescope lsp_references<CR>", vim.tbl_extend("force", opts, { desc = "Go to references" }))
    map("n", "gr", "<cmd>Telescope lsp_references<CR>", vim.tbl_extend("force", opts, { desc = "Go to references" }))
    map("n", "gi", "<cmd>Telescope lsp_implementations<CR>",
        vim.tbl_extend("force", opts, { desc = "Go to implementations" }))
    map("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>",
        vim.tbl_extend("force", opts, { desc = "Go to type definition" }))

    -- Documentation
    map("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover documentation" }))

    -- Code actions (leader + c)
    map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code action" }))
    map("n", "<leader>cn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename symbol" }))

    -- Diagnostics (leader + D for buffer list; float lives on <leader>xf)
    map("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>",
        vim.tbl_extend("force", opts, { desc = "Buffer diagnostics" }))

    -- Diagnostic jumps
    map("n", "[d", vim.diagnostic.goto_prev, vim.tbl_extend("force", opts, { desc = "Previous diagnostic" }))
    map("n", "]d", vim.diagnostic.goto_next, vim.tbl_extend("force", opts, { desc = "Next diagnostic" }))

    -- LSP restart
    map("n", "<leader>cR", "<cmd>lsp restart<CR>", vim.tbl_extend("force", opts, { desc = "Restart LSP" }))

    -- Codelens
    if client:supports_method("textDocument/codeLens", bufnr) then
        map("n", "<leader>cl", vim.lsp.codelens.run, vim.tbl_extend("force", opts, { desc = "Run codelens" }))
    end
end

---Setup LSP features for a buffer
---@param client vim.lsp.Client
---@param bufnr integer
local function on_attach(client, bufnr)
    setup_keymaps(client, bufnr)
    setup_codelens(client, bufnr)
end

-- LspAttach autocmd
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
    callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if not client then
            return
        end
        on_attach(client, ev.buf)

        if client.name == "svelte" then
            local svelte_group = vim.api.nvim_create_augroup("rishav_svelte_notify_" .. ev.buf, { clear = true })
            vim.api.nvim_create_autocmd("BufWritePost", {
                group = svelte_group,
                pattern = { "*.js", "*.ts" },
                callback = function(ctx)
                    if client:is_active() then
                        client.notify("$/onDidChangeTsOrJsFile", { uri = vim.uri_from_fname(ctx.match) })
                    end
                end,
            })
        end
    end,
})

-- Configure diagnostic signs using icons module
vim.diagnostic.config({
    signs = icons.get_diagnostic_signs(),
    float = {
        border = "rounded",
    },
    virtual_text = true,
})

-- Configure floating windows with rounded borders (Neovim 0.11+)
vim.o.winborder = "rounded"
