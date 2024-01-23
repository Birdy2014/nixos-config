require("indent-o-matic").setup {
    max_lines = 2048,
    standard_widths = { 2, 4, 8 },
    filetype_bash = {
        -- workaround for a very strange bug where the indent seems to only be taken from line 19???
        skip_multiline = false
    }
}
