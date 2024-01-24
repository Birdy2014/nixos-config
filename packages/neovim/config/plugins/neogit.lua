local neogit = require("neogit")

neogit.setup {
    ignored_settings = {
        "NeogitPushPopup--force-with-lease",
        "NeogitPushPopup--force",
        "NeogitCommitPopup--allow-empty",
    },
    integrations = {
        diffview = true
    },
    disable_commit_confirmation = true -- Workaround for https://github.com/folke/noice.nvim/issues/232
}

vim.api.nvim_create_autocmd("FileType", {
    pattern = "NeogitCommitMessage",
    callback = function()
        vim.opt_local.spell = true
    end
})

vim.keymap.set("n", "<leader>tg", function()
    neogit.open({ kind = "split" })
end, { desc = "Neogit" })
