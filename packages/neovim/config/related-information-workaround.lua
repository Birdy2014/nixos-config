-- Workaround for https://github.com/neovim/neovim/issues/19649 taken from https://github.com/neovim/neovim/issues/19649#issuecomment-1327287313
local function getlines(location)
    local uri = location.targetUri or location.uri
    if uri == nil then
        return
    end
    local bufnr = vim.uri_to_bufnr(uri)
    if not vim.api.nvim_buf_is_loaded(bufnr) then
        vim.fn.bufload(bufnr)
    end
    local range = location.targetRange or location.range

    local lines = vim.api.nvim_buf_get_lines(bufnr, range.start.line, range["end"].line+1, false)
    return table.concat(lines, "\n")
end

vim.diagnostic.config({float = {format = function(diag)
    local message = diag.message
    local client = vim.lsp.get_active_clients({name = message.source})[1]
    if not client then
        return diag.message
    end

    local relatedInfo = {messages = {}, locations = {}}
    if diag.user_data.lsp.relatedInformation ~= nil then
        for _, info in ipairs(diag.user_data.lsp.relatedInformation) do
            table.insert(relatedInfo.messages, info.message)
            table.insert(relatedInfo.locations, info.location)
        end
    end

    for i, loc in ipairs(vim.lsp.util.locations_to_items(relatedInfo.locations, client.offset_encoding)) do
        message = string.format("%s\n%s (%s:%d):\n\t%s", message, relatedInfo.messages[i],
            vim.fn.fnamemodify(loc.filename, ":."), loc.lnum,
            getlines(relatedInfo.locations[i]))
    end

    return message
end}})
