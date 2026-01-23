vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("my-lsp", {}),
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        local bufnr = vim.api.nvim_get_current_buf()

        if client:supports_method("textDocument/hover") then
            vim.keymap.set("n", "K", function()
                vim.lsp.buf.hover({
                    max_width = math.floor(vim.o.columns * 0.75),
                    max_height = math.floor(vim.o.lines * 0.5),
                })
            end, { desc = "LSP hover", buffer = bufnr })
        end

        if client:supports_method("textDocument/inlayHint") then
            vim.lsp.inlay_hint.enable(true, { bufnr })
        end

        if client:supports_method("textDocument/formatting") then
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = vim.api.nvim_create_augroup("my-lsp", { clear = false }),
                buffer = args.buf,
                callback = function()
                    if
                        (client.name == "clangd" and vim.uv.fs_stat(".clang-format"))
                        or client.name == "rust_analyzer"
                    then
                        vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
                    end
                end,
            })
        end
    end,
})

-- nixd and treefmt are pretty bad at integrating into neovim...
-- When using vim.lsp.buf.format, it will just clear the current file,
-- so this is the best I could come up with.
vim.api.nvim_create_autocmd("BufWritePost", {
    group = vim.api.nvim_create_augroup("format-post", {}),
    callback = function(args)
        if vim.bo.filetype == "nix" and vim.fs.root(args.buf, "flake.nix") ~= nil then
            if vim.g.nix_formatter_path == nil or vim.fn.filereadable(vim.g.nix_formatter_path) == 0 then
                local formatter_output = vim.system({ "nix", "formatter", "build", "--no-link" }):wait(10000)
                vim.g.nix_formatter_path = formatter_output.stdout:sub(1, -2)
            end
            vim.system({ vim.g.nix_formatter_path, args.file }):wait(1000)
            vim.cmd("e")
        end
    end,
})

vim.lsp.config.rust_analyzer = {
    settings = {
        ["rust-analyzer"] = {
            check = {
                command = "clippy",
            },
        },
    },
}

vim.lsp.config.texlab = {
    settings = {
        texlab = {
            build = {
                executable = "latexmk",
                args = {
                    "-pdflua",
                    "-bibtex-cond",
                    "-bibfudge",
                    "-interaction=nonstopmode",
                    "-auxdir=./build/",
                    "-outdir=./build/",
                    "-synctex=1",
                    "%f",
                },
                auxDirectory = "./build/",
                logDirectory = "./build/",
                pdfDirectory = "./build/",
                onSave = true,
            },
            forwardSearch = {
                executable = "zathura",
                args = {
                    "--synctex-forward",
                    "%l:1:%f",
                    "%p",
                },
            },
        },
    },
}

vim.lsp.config.clangd = {
    cmd = { "clangd", "--header-insertion=never" },

    -- possible workaround for stuck diagnostics
    -- TODO: Is this still needed?
    flags = {
        allow_incremental_sync = false,
        debounce_text_changes = 500,
    },

    root_dir = function(bufnr, cb)
        for _, marker in pairs({
            "compile_commands.json",
            "compile_flags.txt",
            ".clangd",
            { "build", "compile_commands.json" },
        }) do
            local depth = 1

            if type(marker) == "table" then
                depth = #marker
                marker = vim.fs.joinpath(unpack(marker))
            end

            local root_dir = vim.fs.root(bufnr, marker)
            if root_dir ~= nil then
                while depth > 1 do
                    root_dir = vim.fs.dirname(root_dir)
                    depth = depth - 1
                end
                if vim.fn.filereadable(vim.fs.joinpath(root_dir, marker)) == 1 then
                    cb(root_dir)
                    return
                end
            end
        end
    end,
}

vim.lsp.enable({ "clangd", "pyright", "rust_analyzer", "ts_ls", "bashls", "texlab", "nixd", "zls" })

vim.diagnostic.config({
    virtual_text = true,
    underline = true,
    update_in_insert = true,
    severity_sort = true,
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.INFO] = " ",
            [vim.diagnostic.severity.HINT] = "󰠠 ",
        },
    },
})

vim.keymap.set("n", "ga", vim.lsp.buf.code_action, { desc = "Code Action" })
vim.keymap.set("n", "gr", vim.lsp.buf.rename, { desc = "Rename symbol" })
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Declaration" })
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Definition" })
vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Implementation" })

vim.keymap.set("n", "[d", function()
    vim.diagnostic.jump({ count = -1 })
end, { desc = "Previous Diagnostic" })

vim.keymap.set("n", "]d", function()
    vim.diagnostic.jump({ count = 1 })
end, { desc = "Next Diagnostic" })

vim.keymap.set("n", "[D", function()
    vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR })
end, { desc = "Previous Error Diagnostic" })

vim.keymap.set("n", "]D", function()
    vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR })
end, { desc = "Next Error Diagnostic" })

vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Open Diagnostic float" })
