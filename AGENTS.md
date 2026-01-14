# AGENTS.md - Neovim Configuration Repository

This document provides essential information for agentic coding assistants working in this Neovim configuration repository.

## Build/Lint/Test Commands

### Formatting
- **Format Lua files**: `stylua lua/`
- **Format all supported files**: Use `<leader>l` in Neovim (conform.nvim)
- **Check Lua formatting**: `stylua --check lua/`

### Linting
- **Lint current file**: Use `<leader>a` in Neovim (nvim-lint)
- **Available linters by filetype**:
  - Python: pylint

### Testing
This is a Neovim configuration repository with no traditional test suite. Configuration changes should be tested manually by:
1. Opening Neovim and verifying functionality
2. Testing plugin integrations
3. Checking for syntax errors with `:luafile %`

### Plugin Management
- **Update plugins**: `Lazy update` (in Neovim)
- **Check plugin status**: `Lazy` (in Neovim)
- **Clean unused plugins**: `Lazy clean` (in Neovim)

## Code Style Guidelines

### Lua Code Style

#### Formatting (.stylua.toml)
```toml
indent_type = "Spaces"
indent_width = 4
```

#### File Structure
- Use modular organization: `lua/rishav/{core,plugins,lsp}/`
- Plugin configurations in `lua/rishav/plugins/`
- Core functionality in `lua/rishav/core/`
- LSP configurations in `lua/rishav/plugins/lsp/`

#### Naming Conventions
- **Functions**: `camelCase` for local functions, `PascalCase` for module-level functions
- **Variables**: `snake_case` for locals, `camelCase` for module variables
- **Files**: `snake_case.lua` (e.g., `colorscheme.lua`, `keymaps.lua`)
- **Directories**: `snake_case` (e.g., `core`, `plugins`)

#### Imports and Requires
```lua
-- Preferred: Use local requires at top of file
local telescope = require("telescope")
local actions = require("telescope.actions")

-- Avoid: Global requires in function bodies
```

#### Plugin Configuration Pattern
```lua
return {
    "plugin/name",
    dependencies = { "dep1", "dep2" },
    config = function()
        local plugin = require("plugin")
        plugin.setup({
            -- configuration options
        })

        -- Keymaps
        local keymap = vim.keymap
        keymap.set("n", "<leader>xx", "<cmd>PluginCommand<cr>", { desc = "Description" })
    end,
}
```

#### Options and Settings
```lua
-- Preferred: Use local opt variable
local opt = vim.opt
opt.relativenumber = true
opt.number = true

-- Avoid: Direct vim.opt calls scattered throughout
vim.opt.tabstop = 4
```

#### Functions
```lua
-- Preferred: Local functions for file scope
local function set_custom_highlights()
    -- implementation
end

-- Avoid: Global functions unless necessary
function SetHighlights()
    -- implementation
end
```

#### Error Handling
```lua
-- Preferred: Use pcall for optional requires
local ok, plugin = pcall(require, "optional_plugin")
if ok then
    plugin.setup({})
end

-- Avoid: Bare requires that might fail
require("might_not_exist")
```

#### Autocommands
```lua
-- Preferred: Use vim.api with descriptive group names
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking text",
    group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
    callback = function()
        vim.hl.on_yank()
    end,
})
```

#### Keymaps
```lua
-- Preferred: Always include descriptive desc field
local keymap = vim.keymap
keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", {
    desc = "Fuzzy find files in cwd"
})

-- Avoid: Keymaps without descriptions
keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>")
```

#### Comments
```lua
-- Preferred: Descriptive comments for complex logic
-- Transparent background setup for multiple UI elements
local transparent_groups = {
    "Normal",
    "NormalFloat",
    -- ... more groups
}

-- Avoid: Obvious comments
-- Set number to true
opt.number = true
```

### Vim Script (when used)
```vim
" Use vim.cmd for Vim script commands
vim.cmd("let g:netrw_liststyle = 3")
```

### Plugin-Specific Guidelines

#### Lazy.nvim Plugins
- Use `lazy = false` for essential plugins loaded at startup
- Set appropriate `priority` values for load order
- Group related plugins in the same file when possible
- Document dependencies clearly

#### LSP Configuration
- LSP server setups in `lua/rishav/plugins/lsp/`
- Use mason for LSP server management
- Follow language-specific naming (e.g., `ts_ls.lua` for TypeScript)

#### Filetype Plugins
- Located in `after/ftplugin/`
- Minimal, filetype-specific settings only
- Avoid complex logic

### Security and Best Practices
- Avoid storing secrets or sensitive data
- Use secure practices for any shell commands
- Validate plugin sources and dependencies
- Keep plugin versions up to date

### Git Workflow
- Commit messages should be descriptive and follow conventional format
- Test changes in a clean Neovim session before committing
- Use feature branches for significant changes
- Keep configuration modular for easy maintenance

### Performance Considerations
- Lazy-load plugins when possible
- Use appropriate event triggers for plugin loading
- Minimize startup time impact
- Profile performance with `:Lazy profile`

## Development Workflow

1. **Make changes** to configuration files
2. **Test manually** by restarting Neovim or sourcing files
3. **Format code** with stylua and conform
4. **Commit changes** with descriptive messages
5. **Update plugins** periodically with Lazy

## File Organization Reference

```
├── init.lua                 # Main entry point
├── lua/rishav/
│   ├── core/                # Core functionality
│   │   ├── init.lua
│   │   ├── options.lua      # Vim options
│   │   ├── keymaps.lua      # Key mappings
│   │   └── *.lua
│   ├── plugins/             # Plugin configurations
│   │   ├── init.lua
│   │   ├── lsp/            # LSP-specific plugins
│   │   └── *.lua
│   ├── lazy.lua            # Plugin manager setup
│   └── lsp.lua             # LSP configuration
├── after/
│   ├── ftplugin/           # Filetype-specific settings
│   └── lsp/                # LSP server configurations
├── .stylua.toml            # Lua formatter config
└── lazy-lock.json          # Plugin lockfile
```</content>
<parameter name="filePath">/home/rishav/.config/nvim/AGENTS.md