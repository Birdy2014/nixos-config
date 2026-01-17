local hop = require("hop")

hop.setup()

vim.keymap.set({ "n", "v" }, "s", hop.hint_char2, {
    desc = "Hop words",
})
vim.keymap.set({ "n", "v" }, "S", hop.hint_words, {
    desc = "Hop words",
})
