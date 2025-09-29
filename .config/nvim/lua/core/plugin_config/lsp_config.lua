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
vim.lsp.config("clangd", {})

-- Go
vim.lsp.config("gopls", {
    capabilities = require('cmp_nvim_lsp').default_capabilities()
})

-- Python
vim.lsp.config("ruff", {
    settings = {
        args = {
            "--line-length=100",
        },
    },
})
vim.lsp.config("pyright", {})

-- TS
vim.lsp.config("ts_ls", {})
vim.lsp.config("eslint", {})

-- Lua
vim.lsp.config("lua_ls", {})
