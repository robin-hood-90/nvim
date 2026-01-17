---@module "rishav.core.terminal"
---Terminal management with floating and split terminal support
local utils = require("rishav.core.utils")

local map = utils.map

---@class TerminalState
---@field buf integer
---@field win integer

---@type table<string, TerminalState>
local terminals = {
    floating = { buf = -1, win = -1 },
    bottom = { buf = -1, win = -1 },
}

---Create a floating window
---@param opts? {width?: number, height?: number, buf?: integer}
---@return TerminalState
local function create_floating_window(opts)
    opts = opts or {}
    local width = opts.width or math.floor(vim.o.columns * 0.85)
    local height = opts.height or math.floor(vim.o.lines * 0.85)

    local col = math.floor((vim.o.columns - width) / 2)
    local row = math.floor((vim.o.lines - height) / 2)

    local buf = vim.api.nvim_buf_is_valid(opts.buf or -1) and opts.buf or vim.api.nvim_create_buf(false, true)

    local win_config = {
        relative = "editor",
        width = width,
        height = height,
        col = col,
        row = row,
        style = "minimal",
        border = "rounded",
        title = " Terminal ",
        title_pos = "center",
    }

    local win = vim.api.nvim_open_win(buf, true, win_config)

    -- Set window options for better terminal visibility
    vim.wo[win].winblend = 0
    vim.wo[win].winhighlight = "Normal:Normal,FloatBorder:FloatBorder"

    return { buf = buf, win = win }
end

---Toggle the floating terminal
local function toggle_floating_terminal()
    if vim.api.nvim_win_is_valid(terminals.floating.win) then
        vim.api.nvim_win_hide(terminals.floating.win)
        return
    end

    terminals.floating = create_floating_window({ buf = terminals.floating.buf })

    if vim.bo[terminals.floating.buf].buftype ~= "terminal" then
        vim.cmd.terminal()
    end

    vim.cmd.startinsert()
end

---Toggle the bottom split terminal
local function toggle_bottom_terminal()
    if vim.api.nvim_win_is_valid(terminals.bottom.win) then
        vim.api.nvim_win_hide(terminals.bottom.win)
        return
    end

    -- Create buffer if needed
    if not vim.api.nvim_buf_is_valid(terminals.bottom.buf) then
        terminals.bottom.buf = vim.api.nvim_create_buf(false, true)
    end

    -- Create split
    vim.cmd("botright split")
    terminals.bottom.win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(terminals.bottom.win, terminals.bottom.buf)
    vim.api.nvim_win_set_height(terminals.bottom.win, 12)

    -- Start terminal if needed
    if vim.bo[terminals.bottom.buf].buftype ~= "terminal" then
        vim.cmd.terminal()
    end

    vim.cmd.startinsert()
end

---Send command to terminal
---@param cmd string
---@param terminal_type? "floating"|"bottom"
local function send_to_terminal(cmd, terminal_type)
    terminal_type = terminal_type or "bottom"
    local term = terminals[terminal_type]

    if not vim.api.nvim_buf_is_valid(term.buf) then
        vim.notify("Terminal not running", vim.log.levels.WARN)
        return
    end

    local chan = vim.bo[term.buf].channel
    if chan then
        vim.api.nvim_chan_send(chan, cmd .. "\n")
    end
end

--------------------------------------------------------------------------------
-- User Commands
--------------------------------------------------------------------------------
vim.api.nvim_create_user_command("Floaterminal", toggle_floating_terminal, {
    desc = "Toggle floating terminal",
})

vim.api.nvim_create_user_command("TermSend", function(opts)
    send_to_terminal(opts.args)
end, {
    nargs = "+",
    desc = "Send command to terminal",
})

--------------------------------------------------------------------------------
-- Keymaps
--------------------------------------------------------------------------------
-- Terminal escape
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Toggle terminals
map({ "n", "t" }, "<leader>tt", toggle_floating_terminal, { desc = "Toggle floating terminal" })
map({ "n", "t" }, "<C-t>", toggle_bottom_terminal, { desc = "Toggle bottom terminal" })

-- Terminal navigation (use Ctrl+hjkl to navigate out of terminal)
map("t", "<C-h>", "<C-\\><C-n><C-w>h", { desc = "Go to left window" })
map("t", "<C-j>", "<C-\\><C-n><C-w>j", { desc = "Go to lower window" })
map("t", "<C-k>", "<C-\\><C-n><C-w>k", { desc = "Go to upper window" })
map("t", "<C-l>", "<C-\\><C-n><C-w>l", { desc = "Go to right window" })

return {
    toggle_floating = toggle_floating_terminal,
    toggle_bottom = toggle_bottom_terminal,
    send = send_to_terminal,
}
