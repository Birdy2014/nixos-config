require("snacks").setup {
    input = { },
    picker = {
        ui_select = true,
    },
}

vim.keymap.set("n", "<leader>ff", Snacks.picker.files, { desc = "Find Files" })
vim.keymap.set("n", "<leader>fl", Snacks.picker.grep, { desc = "Find Lines" })
vim.keymap.set("n", "<leader>fb", Snacks.picker.buffers, { desc = "Find Buffers" })
vim.keymap.set("n", "<leader>fh", Snacks.picker.help, { desc = "Find Help" })
vim.keymap.set("n", "<leader>fs", Snacks.picker.lsp_workspace_symbols, { desc = "Find LSP Symbols" })
vim.keymap.set("n", "<leader>fm", Snacks.picker.man, { desc = "Find Man Pages" })
vim.keymap.set("n", "gh", function () Snacks.picker.lsp_references({ auto_confirm = false, }) end, { desc = "Find LSP References" })
