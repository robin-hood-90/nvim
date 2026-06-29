---@class Icons
---Centralized icons configuration for consistent UI across the config
local M = {}

-- Diagnostic icons
M.diagnostics = {
    Error = " ",
    Warn  = " ",
    Hint  = " ",
    Info  = " ",
}

-- Git icons
M.git = {
    added = " ",
    modified = " ",
    removed = " ",
    renamed = "󰁕 ",
    untracked = " ",
    ignored = " ",
    unstaged = "󰄱 ",
    staged = " ",
    conflict = " ",
    branch = "",
}

-- File/folder icons
M.files = {
    file = " ",
    folder = " ",
    folder_open = " ",
    folder_empty = " ",
    folder_empty_open = " ",
    symlink = " ",
    symlink_folder = " ",
}

-- UI icons
M.ui = {
    arrow_right = "",
    arrow_left = "",
    arrow_up = "",
    arrow_down = "",
    circle = "",
    circle_dot = " ",
    circle_empty = "",
    dot = "•",
    ellipsis = "…",
    check = " ",
    cross = " ",
    plus = " ",
    minus = " ",
    separator = "│",
    vertical_bar = "▎",
    chevron_right = "",
    chevron_down = "",
}

-- LSP kind icons (for completion)
M.kinds = {
    Array = " ",
    Boolean = "󰨙 ",
    Class = " ",
    Codeium = "󰘦 ",
    Color = " ",
    Control = " ",
    Collapsed = " ",
    Constant = "󰏿 ",
    Constructor = " ",
    Copilot = " ",
    Enum = " ",
    EnumMember = " ",
    Event = " ",
    Field = " ",
    File = " ",
    Folder = " ",
    Function = "󰊕 ",
    Interface = " ",
    Key = " ",
    Keyword = " ",
    Method = "󰊕 ",
    Module = " ",
    Namespace = "󰦮 ",
    Null = " ",
    Number = "󰎠 ",
    Object = " ",
    Operator = " ",
    Package = " ",
    Property = " ",
    Reference = " ",
    Snippet = "󱄽 ",
    String = " ",
    Struct = "󰆼 ",
    Supermaven = " ",
    TabNine = "󰏚 ",
    Text = " ",
    TypeParameter = " ",
    Unit = " ",
    Value = " ",
    Variable = "󰀫 ",
}

-- DAP (Debug Adapter Protocol) icons
M.dap = {
    breakpoint = "",
    breakpoint_condition = "",
    log_point = "",
    stopped = "󰁕",
    rejected = "",
    pause = "",
    play = "",
    step_into = "",
    step_over = "",
    step_out = "",
    step_back = "",
    run_last = "",
    terminate = "",
}

-- Mason icons
M.mason = {
    package_installed = "✓",
    package_pending = "➜",
    package_uninstalled = "✗",
}

-- Neotest icons
M.neotest = {
    passed = "",
    failed = "",
    running = "",
    skipped = "",
    unknown = "",
    watching = "",
    non_collapsible = "─",
    collapsed = "",
    expanded = "",
    child_prefix = "├",
    final_child_prefix = "╰",
    child_indent = "│",
    final_child_indent = " ",
}

-- Border styles
M.borders = {
    rounded = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
    single = { "┌", "─", "┐", "│", "┘", "─", "└", "│" },
    double = { "╔", "═", "╗", "║", "╝", "═", "╚", "║" },
    solid = { "▛", "▀", "▜", "▐", "▟", "▄", "▙", "▌" },
    none = { "", "", "", "", "", "", "", "" },
}

-- Spinner frames for loading animations
M.spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }

---Get diagnostic icons table for vim.diagnostic.config
---@return table
function M.get_diagnostic_signs()
    local severity = vim.diagnostic.severity
    return {
        text = {
            [severity.ERROR] = M.diagnostics.Error,
            [severity.WARN] = M.diagnostics.Warn,
            [severity.HINT] = M.diagnostics.Hint,
            [severity.INFO] = M.diagnostics.Info,
        },
    }
end

return M
