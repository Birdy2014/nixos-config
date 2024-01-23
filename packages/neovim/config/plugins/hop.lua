local hop = require("hop")

hop.setup {
    keys = "asdghklöqwertyuiopzxcvbnmfjä"
}

vim.keymap.set({"n", "v"}, "s", hop.hint_words, {
    desc = "Hop words";
})
vim.keymap.set({"n", "v"}, "S", function() hop.hint_words({ multi_windows = true }) end, {
    desc = "Hop word Multi Window"
})
