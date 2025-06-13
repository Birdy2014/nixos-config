function project_picker()
    -- requires `fd`
    Snacks.picker.projects({
        dev = { "~/src" },
    })
end

require("snacks").setup({
    input = {
        enabled = true,
    },

    picker = {
        ui_select = true,
    },

    dashboard = {
        sections = {
            { section = "header" },
            { icon = " ", title = "Recent Files", section = "recent_files", cwd = true, indent = 2, padding = 2 },
            { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 2 },
            { section = "keys", gap = 1 },
        },
        preset = {
            keys = {
                { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
                { icon = " ", key = "e", desc = "New File", action = ":ene | startinsert" },
                { icon = " ", key = "l", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
                { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
                { icon = " ", key = "p", desc = "Recent Projects", action = project_picker },
                { icon = " ", key = "q", desc = "Quit", action = ":qa" },
            },
        },
    },
})

vim.keymap.set("n", "<leader>ff", Snacks.picker.files, { desc = "Find Files" })
vim.keymap.set("n", "<leader>fl", Snacks.picker.grep, { desc = "Find Lines" })
vim.keymap.set("n", "<leader>fb", Snacks.picker.buffers, { desc = "Find Buffers" })
vim.keymap.set("n", "<leader>fh", Snacks.picker.help, { desc = "Find Help" })
vim.keymap.set("n", "<leader>fs", Snacks.picker.lsp_workspace_symbols, { desc = "Find LSP Symbols" })
vim.keymap.set("n", "<leader>fm", Snacks.picker.man, { desc = "Find Man Pages" })
vim.keymap.set("n", "<leader>fp", project_picker, { desc = "Find Projects" })
vim.keymap.set("n", "gh", function()
    Snacks.picker.lsp_references({ auto_confirm = false })
end, { desc = "Find LSP References" })
