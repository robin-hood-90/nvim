return {
    "mfussenegger/nvim-dap",
    dependencies = {
        "rcarriga/nvim-dap-ui",
        "nvim-neotest/nvim-nio",
        "theHamsta/nvim-dap-virtual-text",
    },
    -- stylua: ignore
    keys = {
        { "<F5>", function() require("dap").continue() end, desc = "Debug: Continue" },
        { "<F10>", function() require("dap").step_over() end, desc = "Debug: Step Over" },
        { "<F11>", function() require("dap").step_into() end, desc = "Debug: Step Into" },
        { "<F12>", function() require("dap").step_out() end, desc = "Debug: Step Out" },
        { "<leader>Db", function() require("dap").toggle_breakpoint() end, desc = "Debug: Toggle breakpoint" },
        { "<leader>DB", function() require("dap").set_breakpoint(vim.fn.input("Condition: ")) end, desc = "Debug: Conditional breakpoint" },
        { "<leader>Dl", function() require("dap").set_breakpoint(nil, nil, vim.fn.input("Log: ")) end, desc = "Debug: Log point" },
        { "<leader>Dr", function() require("dap").repl.toggle() end, desc = "Debug: Toggle REPL" },
        { "<leader>Du", function() require("dapui").toggle() end, desc = "Debug: Toggle UI" },
        { "<leader>Dc", function() require("dap").run_to_cursor() end, desc = "Debug: Run to cursor" },
        { "<leader>DL", function() require("dap").run_last() end, desc = "Debug: Run last" },
        { "<leader>Dx", function() require("dap").terminate() end, desc = "Debug: Terminate" },
        { "<leader>Dh", function() require("dap.ui.widgets").hover() end, mode = { "n", "v" }, desc = "Debug: Hover" },
        { "<leader>Dp", function() require("dap.ui.widgets").preview() end, mode = { "n", "v" }, desc = "Debug: Preview" },
        { "<leader>Df", function() local w = require("dap.ui.widgets"); w.centered_float(w.frames) end, desc = "Debug: Frames" },
        { "<leader>Ds", function() local w = require("dap.ui.widgets"); w.centered_float(w.scopes) end, desc = "Debug: Scopes" },
        { "<leader>Dw", function() require("dapui").elements.watches.add(vim.fn.expand("<cword>")) end, desc = "Debug: Add watch" },
    },
    config = function()
        local dap = require("dap")
        local dapui = require("dapui")

        -- Define custom breakpoint icons
        vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError", linehl = "", numhl = "" })
        vim.fn.sign_define("DapStopped", { text = "→", texthl = "DiagnosticInfo", linehl = "", numhl = "" })
        vim.fn.sign_define(
            "DapBreakpointRejected",
            { text = "✗", texthl = "DiagnosticWarn", linehl = "", numhl = "" }
        )
        vim.fn.sign_define(
            "DapBreakpointCondition",
            { text = "◆", texthl = "DiagnosticHint", linehl = "", numhl = "" }
        )
        vim.fn.sign_define("DapLogPoint", { text = "📝", texthl = "DiagnosticHint", linehl = "", numhl = "" })

        -- DAP UI setup
        require("dapui").setup({
            layouts = {
                {
                    elements = { "scopes", "breakpoints", "stacks", "watches" },
                    size = 40,
                    position = "left",
                },
                {
                    elements = { "repl", "console" },
                    size = 0.25,
                    position = "bottom",
                },
            },
        })

        -- nvim-dap-virtual-text setup
        require("nvim-dap-virtual-text").setup({
            enabled = true,
            enabled_commands = true,
            highlight_changed_variables = true,
            highlight_new_as_changed = false,
            show_stop_reason = true,
            commented = false,
            only_first_definition = true,
            all_references = false,
            clear_on_continue = false,
            display_callback = function(variable, buf, stackframe, node, options)
                if options.virt_text_pos == "inline" then
                    return " -> " .. variable.value:gsub("%s+", " ")
                else
                    return variable.name .. " = " .. variable.value:gsub("%s+", " ")
                end
            end,
            virt_text_pos = vim.fn.has("nvim-0.10") == 1 and "inline" or "eol",
            all_frames = false,
            virt_lines = false,
            virt_text_win_col = nil,
        })

        -- Python setup
        dap.adapters.python = function(cb, config)
            if config.request == "attach" then
                local port = (config.connect or config).port
                local host = (config.connect or config).host or "127.0.0.1"
                cb({
                    type = "server",
                    port = assert(port, "`connect.port` is required for a python `attach` configuration"),
                    host = host,
                    options = {
                        source_filetype = "python",
                    },
                })
            else
                cb({
                    type = "executable",
                    command = vim.fn.expand("~/.virtualenvs/debugpy/bin/python"),
                    args = { "-m", "debugpy.adapter" },
                    options = {
                        source_filetype = "python",
                    },
                })
            end
        end

        dap.configurations.python = {
            {
                type = "python",
                request = "launch",
                name = "Launch file",
                program = "${file}",
                pythonPath = function()
                    local cwd = vim.fn.getcwd()
                    if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
                        return cwd .. "/venv/bin/python"
                    elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
                        return cwd .. "/.venv/bin/python"
                    else
                        return "/usr/bin/python3"
                    end
                end,
            },
        }

        -- UI listeners
        dap.listeners.before.attach.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.launch.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.event_terminated.dapui_config = function()
            dapui.close()
        end
        dap.listeners.before.event_exited.dapui_config = function()
            dapui.close()
        end
    end,
}
