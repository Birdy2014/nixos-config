require("nvim-treesitter.configs").setup({
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
    indent = {
        enable = true,
    },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "+",
            node_incremental = "+",
            node_decremental = "-",
        },
    },
})

vim.wo.foldmethod = "expr"
vim.wo.foldexpr = "nvim_treesitter#foldexpr()"

-- This might fix the treesitter error when removing lines in some files
-- TODO: Try disabling this on neovim 0.11.4 or 0.12 (NixOS 25.11)
vim.g._ts_force_sync_parsing = true
