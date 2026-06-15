---@module "rishav.core.treesitter"
---Treesitter highlighting and folding using Neovim 0.12 built-in parsers
---
--- Neovim 0.12 ships built-in parsers for lua, vim, vimdoc, query, c,
--- markdown, markdown_inline, python, bash, css, html, json, typescript,
--- tsx, rust, and more. Non-bundled parsers are installed via
--- vim.treesitter.language.add() or :TSInstall from core.

local M = {}

---Parsers used across the config
local parsers = {
    "bash",
    "c",
    "cpp",
    "css",
    "dockerfile",
    "gitignore",
    "go",
    "graphql",
    "html",
    "java",
    "javascript",
    "jsdoc",
    "json",
    "lua",
    "markdown",
    "markdown_inline",
    "prisma",
    "python",
    "query",
    "regex",
    "rust",
    "svelte",
    "tsx",
    "typescript",
    "typst",
    "vim",
    "vimdoc",
    "yaml",
}

-- Filetype patterns (parser names + aliases for jsx/tsx/zsh/sh)
local function build_filetype_patterns()
    local fts = vim.deepcopy(parsers)
    vim.list_extend(fts, { "javascriptreact", "typescriptreact", "zsh", "sh" })
    return fts
end

---Install missing parsers synchronously on startup
local function install_parsers()
    local missing = {}
    for _, lang in ipairs(parsers) do
        local ok, _ = pcall(vim.treesitter.language.inspect, lang)
        if not ok then
            missing[#missing + 1] = lang
        end
    end
    if #missing > 0 then
        vim.notify(
            "[treesitter] Installing parsers: " .. table.concat(missing, ", "),
            vim.log.levels.INFO
        )
        vim.cmd("TSInstallSync " .. table.concat(missing, " "), { mods = { silent = true } })
        vim.notify("[treesitter] Parser installation complete", vim.log.levels.INFO)
    end
end

---Register language aliases (bash parser for zsh/sh files)
local function register_aliases()
    pcall(vim.treesitter.language.register, "bash", { "zsh", "sh" })
end

---Set up highlighting and folding per filetype
local function setup_highlighting_and_folding()
    vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("rishav_treesitter_core", { clear = true }),
        pattern = build_filetype_patterns(),
        callback = function(args)
            pcall(vim.treesitter.start, args.buf)
            vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
            vim.wo[0][0].foldmethod = "expr"
        end,
    })
end

---Warn if tree-sitter CLI is missing (needed for :TSInstall)
local function warn_missing_cli()
    if vim.fn.executable("tree-sitter") == 0 and not vim.g.rishav_warned_tree_sitter_cli then
        vim.g.rishav_warned_tree_sitter_cli = true
        vim.schedule(function()
            vim.notify(
                "[treesitter] tree-sitter-cli not found.\n"
                    .. "Install it to use :TSInstall / :TSUpdate for custom parsers.\n"
                    .. "  cargo install tree-sitter-cli",
                vim.log.levels.WARN
            )
        end)
    end
end

register_aliases()
install_parsers()
setup_highlighting_and_folding()
warn_missing_cli()

return M

