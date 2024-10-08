require("telescope").setup {
    defaults = {
        file_ignore_patterns = {
            "node_modules"
        },
    },
    pickers = {
        lsp_references = {
            theme = "cursor";
        },
    },
}

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find Files" })
vim.keymap.set("n", "<leader>fl", builtin.live_grep, { desc = "Find Lines" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find Buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Find Help" })
vim.keymap.set("n", "<leader>fs", builtin.lsp_dynamic_workspace_symbols, { desc = "Find LSP Symbols" })
vim.keymap.set("n", "<leader>fm", function() builtin.man_pages({ sections = { "ALL" } }) end, { desc = "Find Man Pages" })
vim.keymap.set("n", "gh", function() builtin.lsp_references({ jump_type = "never" }) end, { desc = "Find LSP References" })
