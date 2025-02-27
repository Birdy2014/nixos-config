require("direnv-nvim").setup {
    async = true,
    on_direnv_finished = function ()
        -- Ugly workaround:
        -- Clangd is already started, because clang-tools is included with this neovim build.
        -- However, LspRestart doesn't start not-running lsp servers, so they need to be started separately.
        vim.cmd("LspRestart")
        vim.cmd("LspStart")
    end,
    on_direnv_finished_opts = {
        once = true,
    },
}
