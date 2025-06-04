-- Set vim options

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.g.have_nerd_font = true
vim.g.is_wsl = vim.fn.has('wsl') == 1

vim.g.picker = true and 'telescope' or 'snacks'

-- Load trusted .nvim.lua files on startup
vim.opt.exrc = true

vim.opt.hlsearch = true
vim.opt.wrapscan = false
vim.opt.lazyredraw = false

vim.opt.number = true
vim.opt.relativenumber = true

-- Enable mouse mode
vim.opt.mouse = 'a'

vim.opt.clipboard = 'unnamedplus'

-- Every wrapped line will continue visually indented
vim.opt.breakindent = true
vim.opt.showbreak = '     '

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default, used by gitsigns
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250
vim.opt.timeoutlen = 1000 -- Large enough for =p >p etc in yanky.nvim

vim.opt.splitright = true
-- vim.opt.splitbelow = true

-- Show whitespace characters
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Show pending subsitutions in a small split window
vim.opt.inccommand = 'split'

-- Show which line the cursor is on
vim.opt.cursorline = true

-- Keep some space at top and bottom of screen
vim.opt.scrolloff = 8

vim.opt.completeopt = 'menuone,noselect,preview'
vim.opt.termguicolors = true
vim.opt_global.background = "light"

-- Tab spacing
-- NOTE: vim-sleuth auto-detects settings and may override. See |sleuth|
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true

-- Default fold by { and } markers
vim.opt.foldmethod = "marker"
vim.opt.foldmarker = "{,}"
vim.opt.foldlevel = 100

vim.diagnostic.config({
  virtual_text = true,
  underline = true,
  signs = false,
  jump = {
    float = true,
    wrap = false,
  },
})

------------ [[ Clipboard ]]
-- Immediately set clipboard on Windows, to not delay startup time
-- Taken from /usr/local/share/nvim/runtime/autoload/provider/clipboard.vim
if vim.fn.has('wsl') == 1 then
  local win32yank = vim.fn.exepath('win32yank.exe')
  if win32yank and #win32yank > 0 then
    if vim.fn.getftype(win32yank) == 'link' then
      win32yank = vim.fn.resolve(win32yank)
    end
    vim.g.clipboard = {
      name = 'win32yank-wsl',
      copy = {
        ['+'] = { win32yank, '-i', '--crlf' },
        ['*'] = { win32yank, '-i', '--crlf' },
      },
      paste = {
        ['+'] = { win32yank, '-o', '--lf' },
        ['*'] = { win32yank, '-o', '--lf' },
      },
      cache_enabled = 1,
    }
  else
    print("No win32yank")
  end
end


----- Override vim.ui.open on wsl to use wslview
if vim.fn.has('wsl') == 1 then
  if vim.fn.executable('wslview') == 1 then
    local original_open = vim.ui.open
    vim.ui.open = function(path, opt)
      if opt == nil then
        opt = { cmd = { 'wslview' }, path }
      end
      original_open(path, opt)
    end
  end
end
