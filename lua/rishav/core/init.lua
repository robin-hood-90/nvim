---@module "rishav.core"
---Core configuration loader
---
---This module loads all core configurations in the correct order:
---1. Options - Basic vim options and settings
---2. Treesitter - Highlighting, folding, parser management (built-in 0.12)
---3. Keymaps - Global keybindings
---4. Autocmds - Autocommands
---5. Terminal - Terminal management

-- Load modules in order (options first, as other modules may depend on them)
local modules = {
    "rishav.core.options",
    "rishav.core.treesitter",
    "rishav.core.keymaps",
    "rishav.core.autocmds",
    "rishav.core.terminal",
}

for _, module in ipairs(modules) do
    local ok, err = pcall(require, module)
    if not ok then
        vim.notify("Failed to load " .. module .. ": " .. err, vim.log.levels.ERROR)
    end
end
