local home = os.getenv("HOME")
local workspace_path = home .. "/.local/share/nvim/jdtls-workspace/"
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = workspace_path .. project_name

-- Check if jdtls is available
local status, jdtls = pcall(require, "jdtls")
if not status then
    return
end

-- This ftplugin runs for every Java buffer. jdtls.start_or_attach() handles
-- starting a new client or attaching to an existing one automatically.
-- We don't need manual client tracking - nvim-jdtls does this internally.

-- Helper function to find JAR files
local function get_jdtls_jar()
    local jar =
        vim.fn.glob(home .. "/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar", true)
    if jar == "" then
        vim.notify("JDTLS launcher JAR not found", vim.log.levels.ERROR)
        return nil
    end
    return jar
end

local function get_debug_jar()
    local jar = vim.fn.glob(
        vim.fn.stdpath("data")
            .. "/mason/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar",
        true
    )
    return jar ~= "" and jar or nil
end

local function get_test_jar()
    local jar = vim.fn.glob(vim.fn.stdpath("data") .. "/mason/packages/java-test/extension/server/*.jar", true)
    return jar ~= "" and jar or nil
end

local jdtls_jar = get_jdtls_jar()
if not jdtls_jar then
    vim.notify("Cannot start JDTLS: launcher JAR not found. Run :Mason to install jdtls", vim.log.levels.ERROR)
    return
end

local lombok_jar = home .. "/.local/share/nvim/mason/packages/jdtls/lombok.jar"

-- Build bundles list
local bundles = {}
if vim.fn.filereadable(lombok_jar) == 1 then
    table.insert(bundles, lombok_jar)
end

local debug_jar = get_debug_jar()
if debug_jar then
    table.insert(bundles, debug_jar)
end

local test_jar = get_test_jar()
if test_jar then
    for jar in test_jar:gmatch("[^\n]+") do
        table.insert(bundles, jar)
    end
end

-- Argument input coroutine for DAP
local function arginp()
    return coroutine.create(function(dap_run_co)
        vim.ui.input({ prompt = "Args: " }, function(argstr)
            coroutine.resume(dap_run_co, argstr)
        end)
    end)
end

-- Safe handler wrapper to prevent invalid buffer errors
local function safe_handler(handler)
    return function(err, result, ctx, config)
        if ctx and ctx.bufnr then
            if not vim.api.nvim_buf_is_valid(ctx.bufnr) then
                return
            end
        end
        return handler(err, result, ctx, config)
    end
end

-- Extended client capabilities for jdtls
local extendedClientCapabilities = jdtls.extendedClientCapabilities

-- Configuration for jdtls
local config = {
    cmd = {
        "java",
        "-Declipse.application=org.eclipse.jdt.ls.core.id1",
        "-Dosgi.bundles.defaultStartLevel=4",
        "-Declipse.product=org.eclipse.jdt.ls.core.product",
        "-Dlog.protocol=true",
        "-Dlog.level=ALL",
        "-Xms1g",
        "-Xmx2g",
        "--add-modules=ALL-SYSTEM",
        "--add-opens",
        "java.base/java.util=ALL-UNNAMED",
        "--add-opens",
        "java.base/java.lang=ALL-UNNAMED",
        "-javaagent:" .. lombok_jar,
        "-jar",
        jdtls_jar,
        "-configuration",
        home .. "/.local/share/nvim/mason/packages/jdtls/config_linux",
        "-data",
        workspace_dir,
    },
    root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }),

    settings = {
        java = {
            signatureHelp = { enabled = true },
            extendedClientCapabilities = extendedClientCapabilities,
            eclipse = {
                downloadSources = true,
            },
            maven = {
                downloadSources = true,
                downloadJavadoc = true,
            },
            referencesCodeLens = {
                enabled = true,
            },
            references = {
                includeDecompiledSources = true,
            },
            inlayHints = {
                parameterNames = {
                    enabled = "all",
                },
            },
            saveActions = {
                organizeImports = true,
            },
            completion = {
                favoriteStaticMembers = {
                    "java.util.*",
                    "org.hamcrest.MatcherAssert.assertThat",
                    "org.hamcrest.Matchers.*",
                    "org.hamcrest.CoreMatchers.*",
                    "org.junit.jupiter.api.Assertions.*",
                    "java.util.Objects.requireNonNull",
                    "java.util.Objects.requireNonNullElse",
                    "org.mockito.Mockito.*",
                },
                importOrder = {
                    "java",
                    "jakarta",
                    "javax",
                    "com",
                    "org",
                },
                filteredTypes = {
                    "com.sun.*",
                    "io.micrometer.shaded.*",
                    "java.awt.*",
                    "jdk.*",
                    "sun.*",
                },
            },
            sources = {
                organizeImports = {
                    starThreshold = 9999,
                    staticThreshold = 9999,
                },
            },
            compile = {
                nullAnalysis = {
                    nonnull = {
                        "lombok.NonNull",
                        "javax.annotation.Nonnull",
                        "org.eclipse.jdt.annotation.NonNull",
                        "org.springframework.lang.NonNull",
                    },
                },
            },
            codeGeneration = {
                toString = {
                    template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
                },
                hashCodeEquals = {
                    useJava7Objects = true,
                },
                useBlocks = true,
            },
            configuration = {
                updateBuildConfiguration = "interactive",
            },
        },
        format = {
            enabled = false,
            indent_space = 4,
        },
    },

    handlers = {
        ["language/status"] = safe_handler(vim.lsp.handlers["language/status"] or function() end),
        ["$/progress"] = safe_handler(vim.lsp.handlers["$/progress"]),
    },

    on_attach = function(client, bufnr)
        -- Only proceed if buffer is valid
        if not vim.api.nvim_buf_is_valid(bufnr) then
            return
        end

        -- NOTE: DAP setup is handled via the `dap` option passed to start_or_attach
        -- which ensures it only runs once per client, not per buffer attachment

        -- Set up buffer-local keymaps
        local opts = { buffer = bufnr, silent = true }

        vim.keymap.set("n", "<leader>co", function()
            if vim.api.nvim_buf_is_valid(bufnr) then
                require("jdtls").organize_imports()
            end
        end, vim.tbl_extend("force", opts, { desc = "Organize Imports" }))

        vim.keymap.set("n", "<leader>crv", function()
            if vim.api.nvim_buf_is_valid(bufnr) then
                require("jdtls").extract_variable()
            end
        end, vim.tbl_extend("force", opts, { desc = "Extract Variable" }))

        vim.keymap.set("v", "<leader>crv", function()
            if vim.api.nvim_buf_is_valid(bufnr) then
                require("jdtls").extract_variable({ visual = true })
            end
        end, vim.tbl_extend("force", opts, { desc = "Extract Variable (Visual)" }))

        vim.keymap.set("n", "<leader>crc", function()
            if vim.api.nvim_buf_is_valid(bufnr) then
                require("jdtls").extract_constant()
            end
        end, vim.tbl_extend("force", opts, { desc = "Extract Constant" }))

        vim.keymap.set("v", "<leader>crc", function()
            if vim.api.nvim_buf_is_valid(bufnr) then
                require("jdtls").extract_constant({ visual = true })
            end
        end, vim.tbl_extend("force", opts, { desc = "Extract Constant (Visual)" }))

        vim.keymap.set("v", "<leader>crm", function()
            if vim.api.nvim_buf_is_valid(bufnr) then
                require("jdtls").extract_method({ visual = true })
            end
        end, vim.tbl_extend("force", opts, { desc = "Extract Method" }))

        -- Initial codelens refresh with error handling
        vim.schedule(function()
            if vim.api.nvim_buf_is_valid(bufnr) then
                pcall(vim.lsp.codelens.refresh, { bufnr = bufnr })
            end
        end)
    end,

    init_options = {
        bundles = bundles,
    },
}

-- CRITICAL: Use start_or_attach which handles client management internally
-- This function will either start a new client or attach the buffer to an existing one
-- Pass dap options to let nvim-jdtls handle DAP setup (only once per client)
jdtls.start_or_attach(config, {
    dap = {
        hotcodereplace = "auto",
        config_overrides = {
            args = arginp,
            stepFilters = {
                skipClasses = { "java.lang.ClassLoader" },
            },
        },
    },
})

-- Safe codelens refresh on save (use buffer only, not pattern)
vim.api.nvim_create_autocmd("BufWritePost", {
    buffer = vim.api.nvim_get_current_buf(),
    callback = function(ev)
        vim.schedule(function()
            if vim.api.nvim_buf_is_valid(ev.buf) then
                pcall(vim.lsp.codelens.refresh, { bufnr = ev.buf })
            end
        end)
    end,
})
