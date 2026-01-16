---@class Utils
---@field map fun(mode: string|string[], lhs: string, rhs: string|function, opts?: table): nil
---@field augroup fun(name: string): integer
---@field autocmd fun(event: string|string[], opts: table): integer
---@field has fun(feature: string): boolean
---@field is_loaded fun(plugin: string): boolean
---@field on_attach fun(callback: fun(client: vim.lsp.Client, bufnr: integer)): nil
---@field get_root fun(): string
local M = {}

-- Cache for performance
local cache = {
    has_features = {},
}

---Create a keymap with sensible defaults
---@param mode string|string[]
---@param lhs string
---@param rhs string|function
---@param opts? table
function M.map(mode, lhs, rhs, opts)
    opts = opts or {}
    opts.silent = opts.silent ~= false
    vim.keymap.set(mode, lhs, rhs, opts)
end

---Create an augroup and return its id
---@param name string
---@return integer
function M.augroup(name)
    return vim.api.nvim_create_augroup("rishav_" .. name, { clear = true })
end

---Create an autocmd
---@param event string|string[]
---@param opts table
---@return integer
function M.autocmd(event, opts)
    return vim.api.nvim_create_autocmd(event, opts)
end

---Check if neovim has a feature
---@param feature string
---@return boolean
function M.has(feature)
    if cache.has_features[feature] == nil then
        cache.has_features[feature] = vim.fn.has(feature) == 1
    end
    return cache.has_features[feature]
end

---Check if a plugin is loaded
---@param plugin string
---@return boolean
function M.is_loaded(plugin)
    local lazy_ok, lazy_config = pcall(require, "lazy.core.config")
    if not lazy_ok then
        return false
    end
    return lazy_config.plugins[plugin] ~= nil and lazy_config.plugins[plugin]._.loaded ~= nil
end

---Run callback when LSP attaches to buffer
---@param callback fun(client: vim.lsp.Client, bufnr: integer)
function M.on_attach(callback)
    M.autocmd("LspAttach", {
        group = M.augroup("lsp_attach"),
        callback = function(args)
            local bufnr = args.buf
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            if client then
                callback(client, bufnr)
            end
        end,
    })
end

---Get the root directory of the current project
---@return string
function M.get_root()
    local path = vim.api.nvim_buf_get_name(0)
    if path == "" then
        return vim.uv.cwd() or ""
    end

    -- Look for common root markers
    local root_markers = { ".git", "package.json", "Cargo.toml", "go.mod", "Makefile", ".root" }
    local root = vim.fs.find(root_markers, {
        path = vim.fs.dirname(path),
        upward = true,
        stop = vim.env.HOME,
    })[1]

    if root then
        return vim.fs.dirname(root)
    end

    return vim.uv.cwd() or ""
end

---Safely require a module
---@param module string
---@return any, boolean
function M.safe_require(module)
    local ok, result = pcall(require, module)
    if not ok then
        vim.notify("Failed to load module: " .. module, vim.log.levels.WARN)
        return nil, false
    end
    return result, true
end

---Merge tables recursively
---@param ... table
---@return table
function M.merge(...)
    return vim.tbl_deep_extend("force", ...)
end

---Debounce a function
---@param fn function
---@param ms number
---@return function
function M.debounce(fn, ms)
    local timer = vim.uv.new_timer()
    return function(...)
        local args = { ... }
        timer:stop()
        timer:start(
            ms,
            0,
            vim.schedule_wrap(function()
                fn(unpack(args))
            end)
        )
    end
end

---Throttle a function
---@param fn function
---@param ms number
---@return function
function M.throttle(fn, ms)
    local timer = vim.uv.new_timer()
    local running = false
    return function(...)
        if not running then
            running = true
            local args = { ... }
            timer:start(
                ms,
                0,
                vim.schedule_wrap(function()
                    running = false
                    fn(unpack(args))
                end)
            )
        end
    end
end

---Check if we're running in a fast/minimal mode
---@return boolean
function M.is_minimal()
    return vim.g.minimal_mode == true or vim.env.NVIM_MINIMAL ~= nil
end

---Get visual selection
---@return string
function M.get_visual_selection()
    local _, ls, cs = unpack(vim.fn.getpos("v"))
    local _, le, ce = unpack(vim.fn.getpos("."))
    return table.concat(vim.api.nvim_buf_get_text(0, ls - 1, cs - 1, le - 1, ce, {}), "\n")
end

return M
