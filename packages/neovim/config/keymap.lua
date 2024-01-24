vim.keymap.set({"n", "v"}, "ö", "[", { remap = true })
vim.keymap.set({"n", "v"}, "ä", "]", { remap = true })
vim.keymap.set({"n", "v"}, "öö", "[[")
vim.keymap.set({"n", "v"}, "ää", "]]")
vim.keymap.set({"n", "v"}, "Ö", "{", { remap = true })
vim.keymap.set({"n", "v"}, "Ä", "}", { remap = true })

vim.keymap.set("n", "<esc>", "<cmd>noh<cr>", { desc = "Hide search highlight" })
vim.keymap.set("n", "k", "(v:count == 0 ? 'gk' : 'k')", { expr = true })
vim.keymap.set("n", "j", "(v:count == 0 ? 'gj' : 'j')", { expr = true })

vim.keymap.set("n", "<leader>sh", "<cmd>vs<cr>", { desc = "Split Left" })
vim.keymap.set("n", "<leader>sj", "<cmd>sp<cr>", { desc = "Split Down" })
vim.keymap.set("n", "<leader>sk", "<cmd>sp<cr>", { desc = "Split Up" })
vim.keymap.set("n", "<leader>sl", "<cmd>vs<cr>", { desc = "Split Right" })
