local gitsigns = require("gitsigns")

gitsigns.setup {
    signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
    },
}

vim.keymap.set("n", "[h", gitsigns.prev_hunk, { desc = "Previous git hunk" })
vim.keymap.set("n", "]h", gitsigns.next_hunk, { desc = "Next git hunk" })
