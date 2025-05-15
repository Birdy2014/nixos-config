--- Remove trailing spaces
vim.cmd [[autocmd BufWritePre * %s/\s\+$//e]]

--- Disable syntax highlighting for SSA subtitles due to extremely poor performance
vim.cmd [[autocmd FileType ssa syntax off]]

--- Highlightedjank
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank {
            higroup=(vim.fn["hlexists"]("HighlightedyankRegion") > 0 and "HighlightedyankRegion" or "IncSearch"),
            timeout=200
        }
    end
})
