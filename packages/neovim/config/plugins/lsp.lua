local lspconfig = require("lspconfig")

function on_lsp_attach()
    local clients = vim.lsp.get_active_clients()
    local bufnr = vim.api.nvim_get_current_buf()

    for _, client in ipairs(clients) do
        if client.server_capabilities.goto_definition then
            vim.api.nvim_buf_set_option(bufnr, "tagfunc", "v:lua.vim.lsp.tagfunc")
        end

        if client.server_capabilities.document_formatting then
            vim.api.nvim_buf_set_option(bufnr, "formatexpr", "v:lua.vim.lsp.formatexpr()")
        end
    end
end

-- Required for denols
vim.g.markdown_fenced_languages = {
    "ts=typescript"
}

local servers = { "clangd", "pyright", "rust_analyzer", "tsserver", "bashls", "texlab", "nil_ls", "denols", "zls" }

local server_config = {
    rust_analyzer = {
        ["rust-analyzer"] = {
            checkOnSave = {
                command = "clippy",
            }
        }
    },
    texlab = {
        texlab = {
            build = {
                executable = "pdflatex",
                onSave = true
            }
        }
    }
}

for _, lsp in ipairs(servers) do
    local capabilities = require('cmp_nvim_lsp').default_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = false
    local conf = {
        capabilities,
        on_attach = on_lsp_attach,
        settings = server_config[lsp] or {}
    }
    if lsp == "clangd" then
        conf.cmd = { "clangd", "--header-insertion=never" }

        -- possible workaround for stuck diagnostics with clangd
        conf.flags = {
            allow_incremental_sync = false,
            debounce_text_changes = 500
        }
    elseif lsp == "bashls" then
        conf.filetypes = { "sh", "bash" }
    end
    lspconfig[lsp].setup(conf)
end

local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }

for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = true,
    signs = true,
    underline = true,
    update_in_insert = true,
    severity_sort = true
})

vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
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

vim.keymap.set("n", "<leader>d", function()
    vim.diagnostic.open_float({
        border = vim.g._border,
    });
end, { desc = "Open Diagnostic float" })
