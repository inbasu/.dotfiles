vim.pack.add({ "https://github.com/williamboman/mason.nvim" })
vim.pack.add({ "https://github.com/williamboman/mason-lspconfig.nvim" })
vim.pack.add({ "https://github.com/neovim/nvim-lspconfig" })


require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = {
        "pyright",
        "ruff",
        "clangd",
        "lua_ls",
    }
})

-- C
vim.lsp.config("clangd", {})


-- Python
vim.lsp.config("ruff", {
    settings = {
        args = {
            "--line-length=100",
        },
    },
})
vim.lsp.config("pyright", {})


-- Lua
vim.lsp.config("lua_ls", {})
