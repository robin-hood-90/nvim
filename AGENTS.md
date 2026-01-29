# AGENTS.md - Neovim Configuration

This document provides guidance for AI coding agents working on this Neovim configuration.

## Project Overview

- **Neovim Version**: 0.11.4 (uses modern 0.11+ features like `vim.lsp.config`, `vim.lsp.enable`, `winborder`)
- **Plugin Manager**: lazy.nvim (folke/lazy.nvim)
- **Author**: Rishav
- **Namespace**: All modules under `lua/rishav/`

## Directory Structure

```
~/.config/nvim/
├── init.lua                    # Entry point - loads core, lazy, lsp
├── lazy-lock.json              # Plugin version lockfile (do not edit manually)
├── .stylua.toml                # Lua formatter config
├── .prettierrc                 # JSON/YAML formatter config
├── lua/rishav/
│   ├── core/                   # Core configuration (non-plugin)
│   │   ├── init.lua            # Module loader
│   │   ├── options.lua         # Vim options and settings
│   │   ├── keymaps.lua         # Global keybindings
│   │   ├── autocmds.lua        # Autocommands
│   │   ├── terminal.lua        # Terminal management
│   │   ├── utils.lua           # Utility functions
│   │   └── icons.lua           # Centralized icon definitions
│   ├── plugins/                # Plugin configurations (lazy.nvim specs)
│   │   ├── init.lua            # Base plugins with minimal config
│   │   ├── lsp/                # LSP-related plugins
│   │   │   ├── lsp.lua         # nvim-lspconfig setup
│   │   │   └── mason.lua       # Mason package manager
│   │   └── [plugin].lua        # Individual plugin configs
│   ├── lazy.lua                # lazy.nvim bootstrap and setup
│   └── lsp.lua                 # LSP keymaps and on_attach logic
└── after/
    ├── lsp/                    # Per-server LSP configurations (Neovim 0.11+ style)
    │   └── [server].lua        # e.g., lua_ls.lua, clangd.lua
    └── ftplugin/               # Filetype-specific settings
        └── [filetype].lua      # e.g., java.lua, typescript.lua
```

## Build/Lint/Test Commands

### Health Check

```bash
nvim --headless "+checkhealth" "+qa"
```

### Format Lua Files

```bash
stylua lua/           # Format all Lua files
stylua --check lua/   # Check formatting without changes
```

### Validate Configuration

```bash
nvim --headless -c "lua print('Config loaded successfully')" -c "qa"
```

### Plugin Management

```vim
:Lazy              " Open lazy.nvim UI
:Lazy sync         " Install, clean, and update plugins
:Lazy health       " Check plugin health
:Mason             " Open Mason UI for LSP/tools
:MasonToolsInstall " Install all configured tools
```

### LSP Commands

```vim
:LspInfo           " Show active LSP clients
:LspRestart        " Restart LSP servers
:ConformInfo       " Show formatter configuration
```

## Code Style Guidelines

### Formatting

- **Indentation**: 4 spaces (configured in `.stylua.toml`)
- **Line width**: 90 characters (soft limit via `colorcolumn`)
- **Formatter**: StyLua for Lua, Prettier for JSON/YAML

### Lua Module Structure

Every module file should follow this pattern:

```lua
---@module "rishav.path.to.module"
---Brief description of the module
---
--- Optional detailed documentation
local M = {}

-- Local imports at top
local utils = require("rishav.core.utils")

-- Module code here

return M
```

### Type Annotations

Use LuaLS annotations for all public functions:

```lua
---Brief description
---@param name string The parameter description
---@param opts? table Optional parameters
---@return boolean success Whether the operation succeeded
function M.example(name, opts)
    -- implementation
end
```

### Plugin Specifications

Plugins use lazy.nvim spec format:

```lua
---@module "rishav.plugins.example"
---Brief description
return {
    "author/plugin-name",
    event = { "BufReadPre", "BufNewFile" },  -- Lazy load trigger
    dependencies = { "dependency/plugin" },
    keys = {
        { "<leader>xx", "<cmd>Command<CR>", desc = "Description" },
    },
    opts = {
        -- Plugin options
    },
    config = function(_, opts)
        require("plugin").setup(opts)
    end,
}
```

### LSP Server Configuration (after/lsp/)

For Neovim 0.11+, server configs return a table:

```lua
-- after/lsp/example_ls.lua
return {
    cmd = { "example-language-server" },
    filetypes = { "example" },
    root_markers = { ".git", "config.json" },
    settings = {
        example = {
            option = "value",
        },
    },
}
```

### Naming Conventions

- **Files**: `snake_case.lua`
- **Functions**: `snake_case`
- **Local variables**: `snake_case`
- **Constants**: `SCREAMING_SNAKE_CASE` (rare, prefer local)
- **Plugin configs**: Match plugin name (e.g., `telescope.lua` for telescope.nvim)

### Keymap Conventions

Leader key is `<Space>`. Use consistent prefixes:

| Prefix      | Purpose          | Example                       |
| ----------- | ---------------- | ----------------------------- |
| `<leader>f` | Find (Telescope) | `<leader>ff` find files       |
| `<leader>g` | Git              | `<leader>gs` git status       |
| `<leader>c` | Code/LSP         | `<leader>ca` code action      |
| `<leader>s` | Splits           | `<leader>sv` vertical split   |
| `<leader>t` | Tabs/Terminal    | `<leader>tt` toggle terminal  |
| `<leader>h` | Harpoon          | `<leader>ha` add file         |
| `<leader>u` | UI toggles       | `<leader>uw` toggle wrap      |
| `<leader>d` | Debug (DAP)      | `<leader>dc` continue         |
| `<leader>x` | Diagnostics      | `<leader>xw` workspace diags  |
| `[` / `]`   | Prev/Next        | `[d` prev diagnostic          |
| `g`         | Go to (LSP)      | `gd` go to definition         |

### Error Handling

Use `pcall` for safe requires and fallbacks:

```lua
local ok, module = pcall(require, "optional-module")
if not ok then
    vim.notify("Module not available", vim.log.levels.WARN)
    return
end
```

For user-facing errors, use `vim.notify`:

```lua
vim.notify("Error message", vim.log.levels.ERROR)
vim.notify("Warning message", vim.log.levels.WARN)
vim.notify("Info message", vim.log.levels.INFO)
```

### Icons

Use centralized icons from `rishav.core.icons`:

```lua
local icons = require("rishav.core.icons")
-- icons.diagnostics.Error, icons.git.added, icons.ui.arrow_right, etc.
```

### Utility Functions

Use utilities from `rishav.core.utils`:

```lua
local utils = require("rishav.core.utils")

utils.map(mode, lhs, rhs, opts)        -- Keymap with defaults
utils.augroup(name)                     -- Create augroup (prefixed with "rishav_")
utils.autocmd(event, opts)              -- Create autocmd
utils.safe_require(module)              -- Protected require
utils.debounce(fn, ms)                  -- Debounce function
utils.throttle(fn, ms)                  -- Throttle function
utils.get_root()                        -- Get project root
```

## Key Patterns

### Lazy Loading

Plugins should be lazy-loaded when possible:

- `event = { "BufReadPre", "BufNewFile" }` - Load on file open
- `event = "VeryLazy"` - Load after startup
- `cmd = { "Command" }` - Load on command
- `keys = { ... }` - Load on keymap
- `ft = "filetype"` - Load for filetype

### LSP Setup (Modern 0.11+ Approach)

1. Server configs go in `after/lsp/[server].lua`
2. Capabilities set globally via `vim.lsp.config("*", { capabilities = ... })`
3. Enable servers with `vim.lsp.enable("server_name")`
4. jdtls is special - handled by nvim-jdtls in `after/ftplugin/java.lua`

### Performance Considerations

- Disabled providers: perl, ruby, node (in init.lua)
- Disabled built-in plugins: netrw, gzip, matchit, etc. (in lazy.lua)
- Use `vim.schedule()` for deferred operations
- Use debounce/throttle for frequent operations

## Important Notes

1. **Do not edit `lazy-lock.json`** - It's auto-generated
2. **jdtls is special** - Uses nvim-jdtls, not standard lspconfig
3. **Format on save** is enabled by default (toggle with `<leader>uf`)
4. **Inlay hints** are enabled globally by default
5. **Treesitter** auto-installs parsers
6. **Mason** auto-installs configured LSP servers and tools
