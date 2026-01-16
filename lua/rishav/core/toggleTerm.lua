-- Toggle terminal function
local term_buf = nil
local term_win = nil

local function toggle_terminal()
    -- Check if terminal window is open and valid
    if term_win and vim.api.nvim_win_is_valid(term_win) then
        vim.api.nvim_win_hide(term_win)
        term_win = nil
        return
    end

    -- Create buffer if it doesn't exist or is invalid
    if not term_buf or not vim.api.nvim_buf_is_valid(term_buf) then
        term_buf = vim.api.nvim_create_buf(false, true)
    end

    -- Create split window and set buffer
    vim.cmd("botright split")
    term_win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(term_win, term_buf)
    vim.api.nvim_win_set_height(term_win, 12)

    -- Start terminal if not already started
    if vim.bo[term_buf].buftype ~= "terminal" then
        vim.cmd.terminal()
    end

    -- Enter insert mode
    vim.cmd("startinsert")
end

-- Set the keymap
vim.keymap.set({ "n", "t" }, "<C-t>", toggle_terminal, { noremap = true, silent = true, desc = "Toggle terminal" })
