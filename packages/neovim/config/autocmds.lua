--- Remove trailing spaces
vim.cmd [[autocmd BufWritePre * %s/\s\+$//e]]

--- Enter insert mode when navigating to a terminal
vim.cmd [[autocmd BufWinEnter,WinEnter term://* startinsert]]

--- Format code on save
vim.api.nvim_create_augroup("fmt", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
    group = "fmt",
    callback = function()
        -- FIXME: This is a bad solution, but sync format seems to cause the lsp server to crash. Or does it? What?
        if vim.bo.filetype == "cpp" and vim.fn.filereadable(".clang-format") == 1 then
            vim.lsp.buf.format({ timeout_ms = 2000 })
        elseif vim.bo.filetype == "rust" then
            vim.lsp.buf.format({ timeout_ms = 2000 })
        end
    end
})

--- Highlightedjank
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank {
            higroup=(vim.fn["hlexists"]("HighlightedyankRegion") > 0 and "HighlightedyankRegion" or "IncSearch"),
            timeout=200
        }
    end
})
