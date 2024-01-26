local alpha_config = require("alpha.themes.theta").config
local dashboard = require("alpha.themes.dashboard")
alpha_config.layout[6].val = {
    { type = "text", val = "Quick links", opts = { hl = "SpecialComment", position = "center" } },
    { type = "padding", val = 1 },
    dashboard.button("e", "󰈔  New file", "<cmd>ene<cr>"),
    dashboard.button("SPC f f", "󰈞  Find file", "<cmd>Telescope find_files<cr>"),
    dashboard.button("SPC t t", "󰙅  Open File Tree", "<cmd>NvimTreeToggle<cr>"),
    dashboard.button("q", "󰅙  Quit" , "<cmd>qa<cr>"),
}
require("alpha").setup(alpha_config)
