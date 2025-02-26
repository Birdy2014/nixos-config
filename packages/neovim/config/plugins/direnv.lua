require("direnv-nvim").setup {
    async = true,
    on_direnv_finished = function ()
        -- You may also want to pair this with `autostart = false` in any `lspconfig` calls
        -- See the 'LSP config examples' section further down.
        vim.cmd("LspStart")
    end
}
