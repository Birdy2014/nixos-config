local cmp = require("blink-cmp")
cmp.setup {
    keymap = {
        preset = "none",

        ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-e>"] = { "hide" },
        ["<CR>"] = { "accept", "fallback" },

        ["<C-u>"] = { "scroll_documentation_up", "fallback" },
        ["<C-d>"] = { "scroll_documentation_down", "fallback" },

        ["<Tab>"] = {
            function(cmp)
                if cmp.is_visible() then
                    return cmp.show()
                end
            end,
            function(cmp)
                return cmp.select_next({ on_ghost_text = true, })
            end,
            "fallback"
        },
        ["<S-Tab>"] = {
            function(cmp)
                return cmp.select_prev({ on_ghost_text = true, })
            end,
            "fallback"
        },
        ["<C-Tab>"] = { "snippet_forward", "fallback" },

        ["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
    },

    appearance = {
        nerd_font_variant = "normal";
    },

    completion = {
        keyword = {
            range = "full";
        },
        list = {
            selection = {
                preselect = function(ctx)
                    local filetypes_without_preselect = { "", "plain", "markdown", }
                    return not vim.list_contains(filetypes_without_preselect, vim.bo.filetype)
                end,
                auto_insert = false,
            },
        },
        menu = {
            auto_show = false,
            draw = {
                treesitter = { "lsp" },
            },
        },
        documentation = {
            auto_show = true,
        },
        ghost_text = {
            enabled = true,
        },
    },

    signature = {
        enabled = true,
    },

    cmdline = {
        keymap = {
            preset = "inherit",

            ["<Tab>"] = { "show", "select_next", "fallback" },
        },

        completion = {
            list = {
                selection = {
                    preselect = false,
                    auto_insert = false,
                },
            },
            menu = {
                auto_show = false,
            },
        },
    },
}
