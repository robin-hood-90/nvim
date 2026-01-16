---@module "rishav.lazy"
---Lazy.nvim plugin manager bootstrap and configuration

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- Bootstrap lazy.nvim if not installed
if not vim.uv.fs_stat(lazypath) then
    local out = vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--branch=stable",
        "https://github.com/folke/lazy.nvim.git",
        lazypath,
    })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end

vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
    spec = {
        { import = "rishav.plugins" },
        { import = "rishav.plugins.lsp" },
    },

    defaults = {
        lazy = true, -- Lazy load by default for better startup
        version = false, -- Always use latest commit
    },

    install = {
        colorscheme = { "catppuccin", "habamax" },
        missing = true, -- Install missing plugins on startup
    },

    checker = {
        enabled = true, -- Check for updates
        notify = false, -- Don't notify on updates
        frequency = 86400, -- Check once per day
    },

    change_detection = {
        enabled = true,
        notify = false, -- Don't notify on config changes
    },

    ui = {
        size = { width = 0.8, height = 0.8 },
        border = "rounded",
        backdrop = 60,
        icons = {
            cmd = " ",
            config = "",
            event = " ",
            ft = " ",
            init = " ",
            import = " ",
            keys = " ",
            lazy = "󰒲 ",
            loaded = "●",
            not_loaded = "○",
            plugin = " ",
            runtime = " ",
            require = "󰢱 ",
            source = " ",
            start = " ",
            task = "✔ ",
            list = {
                "●",
                "➜",
                "★",
                "‒",
            },
        },
    },

    performance = {
        cache = {
            enabled = true,
        },
        reset_packpath = true,
        rtp = {
            reset = true, -- Reset rtp to $VIMRUNTIME and config
            disabled_plugins = {
                "gzip",
                "matchit",
                "matchparen",
                "netrwPlugin",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
                "rplugin",
                "spellfile",
            },
        },
    },

    -- Enable profiling (useful for debugging slow startup)
    profiling = {
        loader = false,
        require = false,
    },
})
