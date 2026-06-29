---@module "rishav.core.treesitter"
---Treesitter highlighting and folding using Neovim 0.12 built-in parsers

local M = {}

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

-- Parsers that are aliases and don't have their own grammar
local parser_aliases = {
    tsx = "typescript",
    javascriptreact = "javascript",
    typescriptreact = "typescript",
    jsdoc = "javascript",
}

-- Some grammars have non-standard GitHub repos (not under tree-sitter org)
local repo_urls = {
    dockerfile = "camdencheek/tree-sitter-dockerfile",
    graphql = "bkegley/tree-sitter-graphql",
    prisma = "victorhqc/tree-sitter-prisma",
    svelte = "Himujjal/tree-sitter-svelte",
    yaml = "ikatyang/tree-sitter-yaml",
    typst = "uben0/tree-sitter-typst",
}

local function build_filetype_patterns()
    local fts = vim.deepcopy(parsers)
    vim.list_extend(fts, { "javascriptreact", "typescriptreact", "zsh", "sh" })
    return fts
end

---Install a single parser using tree-sitter CLI
---@return boolean
local function install_parser(lang)
    if vim.fn.executable("tree-sitter") == 0 then
        return false
    end

    local grammars_dir = vim.fn.stdpath("cache") .. "/tree-sitter-grammars"
    vim.fn.mkdir(grammars_dir, "p")

    local repo = repo_urls[lang] or ("tree-sitter/tree-sitter-" .. lang)
    local grammar_path = grammars_dir .. "/" .. lang .. "-grammar"

    if vim.fn.isdirectory(grammar_path) == 0 then
        local url = "https://github.com/" .. repo
        vim.fn.system({ "git", "clone", "--depth", "1", url, grammar_path })
        if vim.v.shell_error ~= 0 then
            return false
        end
    end

    -- Some repos (e.g. typescript) have subdirectories for each grammar
    local build_dir = grammar_path
    if vim.fn.isdirectory(grammar_path .. "/" .. lang) == 1 then
        build_dir = grammar_path .. "/" .. lang
    end

    local so_path = grammar_path .. "/" .. lang .. ".so"
    -- Build with CWD set to grammar dir (needed for external scanners)
    local cwd = vim.fn.getcwd()
    vim.fn.chdir(build_dir)
    vim.fn.system({ "tree-sitter", "build", "--output", so_path, "." })
    vim.fn.chdir(cwd)
    if vim.v.shell_error ~= 0 then
        return false
    end

    local parser_dir = vim.fn.stdpath("data") .. "/parser"
    vim.fn.mkdir(parser_dir, "p")
    local target = parser_dir .. "/" .. lang .. ".so"
    vim.fn.system({ "cp", so_path, target })

    pcall(vim.treesitter.language.add, lang, { path = target })
    return true
end

---Check and install missing parsers
local function install_missing_parsers()
    if vim.fn.executable("tree-sitter") == 0 then
        vim.schedule(function()
            vim.notify(
                "[treesitter] tree-sitter CLI not found. Some parsers may be missing.",
                vim.log.levels.WARN
            )
        end)
        return
    end

    local parser_dir = vim.fn.stdpath("data") .. "/parser"
    local to_install = {}
    for _, lang in ipairs(parsers) do
        local ok, _ = pcall(vim.treesitter.language.inspect, lang)
        if not ok then
            local target = parser_dir .. "/" .. lang .. ".so"
            if vim.fn.filereadable(target) == 1 then
                pcall(vim.treesitter.language.add, lang, { path = target })
            elseif parser_aliases[lang] then
                -- Alias parsers don't need separate install
            else
                to_install[#to_install + 1] = lang
            end
        end
    end

    if #to_install == 0 then
        return
    end

    -- Install in background
    local uv = vim.uv or vim.loop
    if uv then
        local timer = uv.new_timer()
        timer:start(100, 0, vim.schedule_wrap(function()
            timer:stop()
            timer:close()

            local ok_count, fail_count = 0, 0
            for _, lang in ipairs(to_install) do
                if install_parser(lang) then
                    ok_count = ok_count + 1
                else
                    fail_count = fail_count + 1
                end
            end
        end))
    end
end

---Register language aliases
local function register_aliases()
    pcall(vim.treesitter.language.register, "bash", { "zsh", "sh" })
    for alias, target in pairs(parser_aliases) do
        pcall(vim.treesitter.language.register, target, { alias })
    end
end

---Set up highlighting and folding per filetype
local function setup_highlighting_and_folding()
    vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("rishav_treesitter_core", { clear = true }),
        pattern = build_filetype_patterns(),
        callback = function(args)
            pcall(vim.treesitter.start, args.buf)
            pcall(function()
                vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
                vim.wo[0][0].foldmethod = "expr"
            end)
        end,
    })
end

register_aliases()
install_missing_parsers()
setup_highlighting_and_folding()

return M
