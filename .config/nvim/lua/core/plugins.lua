vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packet manager
    use "wbthomason/packer.nvim"
    -- Quality of life
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.8',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }
    use "nvim-tree/nvim-web-devicons"
    use { 'akinsho/bufferline.nvim', tag = "*", requires = 'nvim-tree/nvim-web-devicons' }
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ":TSUpdate"
    }

    -- wiki
    use "vimwiki/vimwiki"

    -- lsp
    use {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "neovim/nvim-lspconfig",
    }
    use "stevearc/conform.nvim"
    use 'mfussenegger/nvim-lint'
    use "hrsh7th/nvim-cmp"         -- completion plugin
    use "hrsh7th/cmp-nvim-lsp"     -- completion plugin
    use "hrsh7th/cmp-buffer"       -- source for text in buffer
    use "L3MON4D3/LuaSnip"         -- snippet engine
    use "saadparwaiz1/cmp_luasnip" -- for autocompletion

    --theme
    use 'kaicataldo/material.vim'
    use 'aliqyan-21/darkvoid.nvim'
    if packer_bootstrap then
        require('packer').sync()
    end
end)
