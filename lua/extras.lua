-- Extra things with no home :(

-- Filter the quickfix list with :Cfilter(!) /pattern/
vim.cmd.packadd('cfilter')
vim.cmd.packadd('nvim.tohtml')

vim.api.nvim_create_user_command('LspInfo', 'checkhealth vim.lsp', {})

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

-- Add DiffOrig command from the docs to diff a file with its recovery file
vim.cmd [[
  command DiffOrig vert new | set buftype=nofile | read ++edit # | 0d_ | diffthis | wincmd p | diffthis
]]
