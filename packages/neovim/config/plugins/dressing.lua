require("dressing").setup {
    input = {
        enabled = false,
    },
    select = {
        enabled = true,
        backend = { "telescope", "builtin" },

        -- Trim trailing `:` from prompt
        trim_prompt = true,

        -- Options for telescope selector
        -- These are passed into the telescope picker directly. Can be used like:
        -- telescope = require("telescope.themes").get_ivy({...})
        telescope = nil,
    }
}
