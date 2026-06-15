vim.api.nvim_create_autocmd("FileType", {
    callback = function(args)
        if pcall(vim.treesitter.start, args.buf) then
            vim.wo.foldmethod = "expr"
            vim.wo.foldexpr = "nvim_treesitter#foldexpr()"
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
    end,
})
