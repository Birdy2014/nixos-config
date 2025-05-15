local lspconfig = require("lspconfig")

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("my-lsp", {}),
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        local bufnr = vim.api.nvim_get_current_buf()

        if client.supports_method("textDocument/definition") then
            vim.api.nvim_buf_set_option(bufnr, "tagfunc", "v:lua.vim.lsp.tagfunc")
        end

        if client.supports_method("textDocument/formatting") then
            vim.api.nvim_buf_set_option(bufnr, "formatexpr", "v:lua.vim.lsp.formatexpr()")
        end

        if client.supports_method("textDocument/inlayHint") then
            vim.lsp.inlay_hint.enable(true, { bufnr })
        end

        if client.supports_method("textDocument/formatting") then
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = vim.api.nvim_create_augroup("my-lsp", { clear = false }),
                buffer = args.buf,
                callback = function()
                    if ((vim.bo.filetype == "cpp" or vim.bo.filetype == "c") and vim.fn.filereadable(".clang-format") == 1)
                        or vim.bo.filetype == "rust" then
                        vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
                    end
                end
            })
        end
    end
})

-- Required for denols
vim.g.markdown_fenced_languages = {
    "ts=typescript"
}

local servers = { "clangd", "pyright", "rust_analyzer", "ts_ls", "bashls", "texlab", "nil_ls", "denols", "zls", "svelte" }

local server_config = {
    rust_analyzer = {
        ["rust-analyzer"] = {
            check = {
                command = "clippy",
            }
        }
    },
    texlab = {
        texlab = {
            build = {
                executable = "latexmk",
                args = {
                    "-pdflua",
                    "-bibtex-cond", "-bibfudge",
                    "-interaction=nonstopmode",
                    "-auxdir=./build/", "-outdir=./build/",
                    "-synctex=1", "%f"
                },
                auxDirectory = "./build/",
                logDirectory = "./build/",
                pdfDirectory = "./build/",
                onSave = true
            },
            forwardSearch = {
                executable = "zathura",
                args = {
                    "--synctex-forward", "%l:1:%f", "%p"
                },
            },
        }
    }
}

for _, lsp in ipairs(servers) do
    local capabilities = require('cmp_nvim_lsp').default_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = false
    local conf = {
        capabilities,
        settings = server_config[lsp] or {}
    }
    if lsp == "clangd" then
        conf.cmd = { "clangd", "--header-insertion=never" }

        -- possible workaround for stuck diagnostics with clangd
        conf.flags = {
            allow_incremental_sync = false,
            debounce_text_changes = 500
        }

        -- start clangd using the autocmd below
        conf.autostart = false;
    elseif lsp == "bashls" then
        conf.filetypes = { "sh", "bash" }
    elseif lsp == "denols" then
        conf.root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc")
    end
    lspconfig[lsp].setup(conf)
end

vim.api.nvim_create_autocmd("FileType", {
    pattern = require("lspconfig.configs")["clangd"].filetypes,
    callback = function()
        local cwd = vim.loop.cwd()
        for _, value in pairs({
            "compile_commands.json",
            "compile_flags.txt",
            ".clangd",
            "build/compile_commands.json"
        }) do
            if vim.fn.filereadable(value) == 1 then
                require("lspconfig.configs")["clangd"].launch()
                return
            end
        end
    end
})

vim.diagnostic.config {
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
        }
    }
}

vim.keymap.set("n", "ga", vim.lsp.buf.code_action, { desc = "Code Action" })
vim.keymap.set("n", "gr", vim.lsp.buf.rename, { desc = "Rename symbol" })
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Declaration" })
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Definition" })
vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Implementation" })

vim.keymap.set("n", "[d", function()
    vim.diagnostic.goto_prev({ float = false })
end, { desc = "Previous Diagnostic" })

vim.keymap.set("n", "]d", function()
    vim.diagnostic.goto_next({ float = false })
end, { desc = "Next Diagnostic" })

vim.keymap.set("n", "[D", function()
    vim.diagnostic.goto_prev({ float = false, severity = vim.diagnostic.severity.ERROR })
end, { desc = "Previous Error Diagnostic" })

vim.keymap.set("n", "]D", function()
    vim.diagnostic.goto_next({ float = false, severity = vim.diagnostic.severity.ERROR })
end, { desc = "Next Error Diagnostic" })

vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Open Diagnostic float" })
