vim.wo.foldmethod = "expr"
vim.wo.foldexpr = "nvim_treesitter#foldexpr()"

vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
