-- nvim-tree requests netrw be disabled asap
-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1

require('options')
require('keymaps')
require('extras')

------------ [[ Install `lazy.nvim` plugin manager ]]
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

------------ [[ Configure and install plugins ]]
require('lazy').setup({
  spec = { { import = 'plugins' } },
  install = {
    colorscheme = { "catppuccin-latte" },
  },
  change_detection = {
    enabled = true,
    notify = false,
  },
}, {})
