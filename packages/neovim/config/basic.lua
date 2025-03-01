vim.g.mapleader = " "

-- basics
vim.opt.compatible = false
vim.opt.hidden = true

-- visual
vim.opt.background = "dark"
vim.opt.breakindentopt = "sbr"
vim.opt.cmdheight = 0
vim.opt.conceallevel = 1
vim.opt.linebreak = true
vim.opt.list = true
vim.opt.listchars = "tab:>-,trail:-,nbsp:+"
vim.opt.number = true
vim.opt.showbreak = "↪ "
vim.opt.showmode = false
vim.opt.termguicolors = true
vim.opt.title = true

-- split
vim.opt.eadirection = "hor"
vim.opt.equalalways = true
vim.opt.splitbelow = true
vim.opt.splitright = true

-- spelling
vim.opt.spelllang = { "en", "de_20" }

-- folding
vim.opt.foldlevel = 99

-- code style
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4

-- mouse
vim.opt.mouse = "a"
vim.opt.mousemodel = "extend"

-- Gui settings
vim.opt.guifont = "monospace:h10"
if vim.g.neovide then
    vim.g.neovide_remember_window_size = false
    vim.g.neovide_scroll_animation_length = 0.2
end

-- other
vim.opt.inccommand = "nosplit"
vim.opt.scrolloff = 1
vim.opt.switchbuf:append("useopen")
vim.opt.timeoutlen = 500
vim.opt.undofile = true
vim.opt.virtualedit = "block"
vim.opt.shell = "/bin/sh" -- Fix performance issues with nvim-tree.lua and potentially some other bugs
vim.opt.backupcopy = "yes" -- Fix reloading issues with parcel
vim.opt.fsync = true -- Prevent potential data loss on system crash
vim.opt.ignorecase = true -- Case insensitive search. Can be overridden using "\C".
vim.opt.smartcase = true -- Case insensitive search only if the pattern is all lowercase. Overrides "ignorecase"
