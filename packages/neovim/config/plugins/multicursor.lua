local mc = require("multicursor-nvim")

mc.setup()

function set(mode, key, func, desc)
    local opts = {}
    if desc ~= nil then
        opts.desc = desc
    end
    vim.keymap.set(mode, key, func, opts)
end

-- TODO: Add more descriptions from https://github.com/jake-stewart/multicursor.nvim, change keymaps and decide what is important

-- Add or skip cursor above/below the main cursor.
set({"n", "x"}, "<up>", function() mc.lineAddCursor(-1) end, "Add cursor above")
set({"n", "x"}, "<down>", function() mc.lineAddCursor(1) end, "Add cursor below")
set({"n", "x"}, "<leader><up>", function() mc.lineSkipCursor(-1) end, "Skip line above")
set({"n", "x"}, "<leader><down>", function() mc.lineSkipCursor(1) end, "Skip line below")

-- Add or skip adding a new cursor by matching word/selection
-- TODO: Change keys / resolve conflicts
set({"n", "x"}, "<leader>n", function() mc.matchAddCursor(1) end, "Add cursor for next match")
-- set({"n", "x"}, "<leader>s", function() mc.matchSkipCursor(1) end, "Skip cursor for next match")
set({"n", "x"}, "<leader>N", function() mc.matchAddCursor(-1) end, "Add cursor for previous match")
-- set({"n", "x"}, "<leader>S", function() mc.matchSkipCursor(-1) end, "Skip cursor for previous match")

-- Add all matches in the document
set({"n", "x"}, "<leader>A", mc.matchAllAddCursors, "Add cursor for every match")

-- Rotate the main cursor.
set({"n", "x"}, "<left>", mc.nextCursor, "Next cursor")
set({"n", "x"}, "<right>", mc.prevCursor, "Previous cursor")

-- Delete the main cursor.
set({"n", "x"}, "<leader>x", mc.deleteCursor, "Delete cursor")

-- Add and remove cursors with control + left click.
set("n", "<c-leftmouse>", mc.handleMouse)
set("n", "<c-leftdrag>", mc.handleMouseDrag)
set("n", "<c-leftrelease>", mc.handleMouseRelease)

-- Easy way to add and remove cursors using the main cursor.
set({"n", "x"}, "<c-q>", mc.toggleCursor, "Toggle cursor")

set("n", "<esc>", function()
    if not mc.cursorsEnabled() then
        mc.enableCursors()
    elseif mc.hasCursors() then
        mc.clearCursors()
    else
        -- Default <esc> handler.
        vim.cmd("nohlsearch")
    end
end)

-- bring back cursors if you accidentally clear them
set("n", "<leader>gv", mc.restoreCursors, "Restore cursors")

-- Align cursor columns.
set("n", "<leader>a", mc.alignCursors)

-- Split visual selections by regex.
-- TODO: Do I need this?
-- set("x", "S", mc.splitCursors)

-- Append/insert for each line of visual selections.
-- TODO: Do I need this? / Use a different key
-- set("x", "I", mc.insertVisual)
-- set("x", "A", mc.appendVisual)

-- match new cursors within visual selections by regex.
set("x", "M", mc.matchCursors, "Add cursors based on regex match")

-- Rotate visual selection contents.
set("x", "<leader>t", function() mc.transposeCursors(1) end)
set("x", "<leader>T", function() mc.transposeCursors(-1) end)

-- Jumplist support
set({"x", "n"}, "<c-i>", mc.jumpForward)
set({"x", "n"}, "<c-o>", mc.jumpBackward)
