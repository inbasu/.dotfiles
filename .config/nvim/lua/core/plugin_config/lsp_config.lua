require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = {
        "gopls",
        "pyright",
        "ruff",
        "ts_ls",
        "eslint",
        "clangd",
        "lua_ls",
    }
})

-- C
require("lspconfig").clangd.setup {}

-- Go
require("lspconfig").gopls.setup {
    capabilities = require('cmp_nvim_lsp').default_capabilities()
}

-- Python
require("lspconfig").ruff.setup {
    settings = {
        args = {
            "--line-length=100",
        },
    },
}
require("lspconfig").pyright.setup {}

-- TS
require("lspconfig").ts_ls.setup {}
require("lspconfig").eslint.setup {}

-- Lua
require("lspconfig").lua_ls.setup {}
