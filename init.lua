--[[
  Neovim Configuration
  Author: Rishav

  Structure:
  ├── init.lua           -- Entry point (this file)
  ├── lua/rishav/
  │   ├── core/          -- Core settings (options, keymaps, autocmds)
  │   ├── plugins/       -- Plugin configurations
  │   └── lsp.lua        -- LSP keymaps and settings
  └── after/lsp/         -- LSP server configurations
]]

-- Performance: Disable some providers early
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0

-- Set leader keys early (before lazy.nvim loads)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Load core configuration first
require("rishav.core")

-- Bootstrap and setup lazy.nvim
require("rishav.lazy")

-- LSP keymaps and settings
require("rishav.lsp")
