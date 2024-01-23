require("barbar").setup {
    icons = {
        button = "",
        modified = {
            button = "",
        },
    },
    letters = "asdfjklöghnmxcvbziowerutyqpASDFJKLGHNMXCVBZIOWERUTYQP",
}

vim.keymap.set("n", "<m-q>", "<cmd>BufferClose<cr>", { desc = "Close Buffer" })
vim.keymap.set("n", "<m-Q>", "<cmd>BufferClose!<cr>", { desc = "Force Close Buffer" })
vim.keymap.set("n", "<m-s>", "<cmd>BufferPick<cr>", { desc = "Pick Buffer" })
vim.keymap.set("n", "<m-k>", "<cmd>BufferPrevious<cr>", { desc = "Previous Buffer" })
vim.keymap.set("n", "<m-j>", "<cmd>BufferNext<cr>", { desc = "Next Buffer" })
vim.keymap.set("n", "<m-K>", "<cmd>BufferMovePrevious<cr>", { desc = "Move Buffer Left" })
vim.keymap.set("n", "<m-J>", "<cmd>BufferMoveNext<cr>", { desc = "Move Buffer Right" })
vim.keymap.set("n", "<m-1>", "<cmd>BufferGoto 1<cr>", { desc = "Buffer 1" })
vim.keymap.set("n", "<m-2>", "<cmd>BufferGoto 2<cr>", { desc = "Buffer 2" })
vim.keymap.set("n", "<m-3>", "<cmd>BufferGoto 3<cr>", { desc = "Buffer 3" })
vim.keymap.set("n", "<m-4>", "<cmd>BufferGoto 4<cr>", { desc = "Buffer 4" })
vim.keymap.set("n", "<m-5>", "<cmd>BufferGoto 5<cr>", { desc = "Buffer 5" })
vim.keymap.set("n", "<m-6>", "<cmd>BufferGoto 6<cr>", { desc = "Buffer 6" })
vim.keymap.set("n", "<m-7>", "<cmd>BufferGoto 7<cr>", { desc = "Buffer 7" })
vim.keymap.set("n", "<m-8>", "<cmd>BufferGoto 8<cr>", { desc = "Buffer 8" })
vim.keymap.set("n", "<m-9>", "<cmd>BufferGoto 9<cr>", { desc = "Buffer 9" })
vim.keymap.set("n", "<m-0>", "<cmd>BufferLast<cr>", { desc = "Last Buffer" })
