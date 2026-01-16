-- IMPORTANT: This file intentionally returns an empty/disabled config
-- JDTLS is configured separately via after/ftplugin/java.lua using nvim-jdtls
-- This prevents nvim-lspconfig from auto-starting a second jdtls instance

-- Return false to disable the built-in jdtls config from nvim-lspconfig
return {
    -- Empty config - effectively disables auto-start
    -- The actual jdtls setup is handled by nvim-jdtls in ftplugin/java.lua
    enabled = false,
}
