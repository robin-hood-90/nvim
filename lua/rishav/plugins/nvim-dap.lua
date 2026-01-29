return {
    "mfussenegger/nvim-dap",
    dependencies = {
        "rcarriga/nvim-dap-ui",
        "nvim-neotest/nvim-nio",
        "theHamsta/nvim-dap-virtual-text",
    },
    -- stylua: ignore
    keys = {
        -- Session control
        { "<leader>dc", function() require("dap").continue() end, desc = "Continue/Start" },
        { "<leader>dq", function() require("dap").terminate() end, desc = "Quit/Terminate" },
        { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
        { "<leader>dp", function() require("dap").pause() end, desc = "Pause" },

        -- Stepping
        { "<leader>ds", function() require("dap").step_over() end, desc = "Step Over" },
        { "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
        { "<leader>do", function() require("dap").step_out() end, desc = "Step Out" },
        { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },

        -- Breakpoints
        { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
        { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Condition: ")) end, desc = "Conditional Breakpoint" },
        { "<leader>dL", function() require("dap").set_breakpoint(nil, nil, vim.fn.input("Log: ")) end, desc = "Log Point" },
        { "<leader>dx", function() require("dap").clear_breakpoints() end, desc = "Clear Breakpoints" },

        -- UI & Inspection
        { "<leader>du", function() require("dapui").toggle() end, desc = "Toggle UI" },
        { "<leader>de", function() require("dapui").eval() end, mode = { "n", "v" }, desc = "Evaluate" },
        { "<leader>dh", function() require("dap.ui.widgets").hover() end, mode = { "n", "v" }, desc = "Hover" },
        { "<leader>df", function() local w = require("dap.ui.widgets"); w.centered_float(w.frames) end, desc = "Frames" },
        { "<leader>dS", function() local w = require("dap.ui.widgets"); w.centered_float(w.scopes) end, desc = "Scopes" },
        { "<leader>dw", function() require("dapui").elements.watches.add(vim.fn.expand("<cword>")) end, desc = "Add Watch" },
        { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },

        -- Function keys (IDE-style, optional fallback)
        { "<F5>", function() require("dap").continue() end, desc = "Debug: Continue" },
        { "<F9>", function() require("dap").toggle_breakpoint() end, desc = "Debug: Toggle Breakpoint" },
        { "<F10>", function() require("dap").step_over() end, desc = "Debug: Step Over" },
        { "<F11>", function() require("dap").step_into() end, desc = "Debug: Step Into" },
        { "<F12>", function() require("dap").step_out() end, desc = "Debug: Step Out" },
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
        ---@diagnostic disable-next-line: missing-fields
        dapui.setup({
            layouts = {
                {
                    elements = {
                        { id = "scopes", size = 0.25 },
                        { id = "breakpoints", size = 0.25 },
                        { id = "stacks", size = 0.25 },
                        { id = "watches", size = 0.25 },
                    },
                    size = 40,
                    position = "left",
                },
                {
                    elements = {
                        { id = "repl", size = 0.5 },
                        { id = "console", size = 0.5 },
                    },
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
