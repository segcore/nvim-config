-- Extra things with no home :(

-- Filter the quickfix list with :Cfilter(!) /pattern/
vim.cmd.packadd('cfilter')


vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Add errorformats
local jai = [[%f:%l\,%v: %t%\a\*:%m]]
vim.o.errorformat = jai .. ',' .. vim.o.errorformat
