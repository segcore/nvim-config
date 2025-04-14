----- LSP
-- Remove default keymaps of nvim 0.11 which conflict
pcall(function()
  vim.keymap.del('n', 'grn')
  vim.keymap.del('n', 'grr')
  vim.keymap.del('n', 'gri')
  vim.keymap.del('n', 'gra')
end)

vim.keymap.set('n', '<C-S-k>', vim.lsp.buf.signature_help, { desc = 'Signature Documentation' })
vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, { desc = 'Signature Documentation' })
vim.keymap.set('i', '<C-S-k>', vim.lsp.buf.hover, { desc = 'Hover Documentation' })
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { desc = 'Goto Declaration' })
vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, { desc = 'Workspace Add Folder' })
vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, { desc = 'Workspace Remove Folder' })
vim.keymap.set('n', '<leader>wl', function()
  print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
end, { desc = 'Workspace List Folders' })
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = 'Rename' })
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'Code Action' })

vim.keymap.set('n', '<leader>hh', function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({}))
end, { desc = 'Toggle inlay hints' })

vim.keymap.set('n', '^', '<cmd>ClangdSwitchSourceHeader<CR>', { desc = 'Switch between source and header' })

----- Diagnostics
vim.keymap.set('n', '[e', function() vim.diagnostic.jump({ severity = vim.diagnostic.severity.ERROR, count = -1 }) end,
  { desc = 'Go to previous error message' })
vim.keymap.set('n', ']e', function() vim.diagnostic.jump({ severity = vim.diagnostic.severity.ERROR, count = 1 }) end,
  { desc = 'Go to next error message' })
vim.keymap.set('n', '<leader>ee', function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
  if vim.diagnostic.is_enabled() then
    print("Diagnostics enabled")
  else
    print("Diagnostics disabled")
  end
end, { desc = 'Toggle diagnostics on/off' })

-----
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Normal mode from terminal' })
vim.keymap.set('n', 'n', 'nzz', { desc = 'next search and center' })
vim.keymap.set('n', 'N', 'Nzz', { desc = 'prev search and center' })
vim.keymap.set('n', '<C-_>', '<cmd>nohlsearch<CR>', { desc = 'Hide search results' })
vim.keymap.set('n', '<C-/>', '<cmd>nohlsearch<CR>', { desc = 'Hide search results' })

vim.keymap.set('n', '<leader>F', '<cmd>let @+=@%<CR>', { desc = 'Copy filename to clipboard' })
vim.keymap.set('n', 'gX', function() vim.ui.open(vim.api.nvim_buf_get_name(0)) end, { desc = 'Open current file with extenal program' })

vim.keymap.set('n', '<leader>S', [[<cmd>s/\s\+$//e<CR>]], { desc = "Clear whitespace at end of line" })
vim.keymap.set('v', '<leader>S', [[<Esc><cmd>'<,'>s/\s\+$//e<CR>]], { desc = "Clear whitespace at end of line" })

vim.keymap.set('n', '<leader>l', '<cmd>.lua<CR>', { desc = 'Run current line as Lua code' })
vim.keymap.set('n', '<leader>L', '<cmd>%lua<CR>', { desc = 'Run the current file as Lua code' })
vim.keymap.set('v', '<leader>l', [[<Esc><cmd>'<,'>lua<CR>]], { desc = 'Run selected lines as Lua code' })

-- visually select the last yanked or inserted text
vim.keymap.set('n', 'gy', "`[v`]", { desc = "Select last inserted or yanked text" })

-- Delete without cutting to registers
vim.keymap.set({'n', 'v'}, '<leader>x', '"_x', { desc = 'Delete char (no registers)' })

-- Remap for word wrap
-- vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
-- vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Jump within the quickfix list
-- (uses cnext/cprev because cfirst and clast are not necessarily the 'real' errors, just the first and last lines)
vim.keymap.set('n', '<A-C-h>', '<cmd>cfirst | cnext<CR>', { desc = 'First quickfix item' })
vim.keymap.set('n', '<A-h>', '<cmd>cprev<CR>', { desc = 'Previous quickfix item' })
vim.keymap.set('n', '<A-l>', '<cmd>cnext<CR>', { desc = 'Next quickfix item' })
vim.keymap.set('n', '<A-C-l>', '<cmd>clast | cprev<CR>', { desc = 'Last quickfix item' })

-- Move lines up and down with Alt-j, Alt-k in normal and visual modes
vim.keymap.set('n', '<A-j>', '<cmd>m .+1<CR>==', { desc = 'Move lines down one' })
vim.keymap.set('n', '<A-k>', '<cmd>m .-2<CR>==', { desc = 'Move lines up one' })
vim.keymap.set('i', '<A-j>', '<Esc><cmd>m .+1<CR>==gi', { desc = 'Move lines down one' })
vim.keymap.set('i', '<A-k>', '<Esc><cmd>m .-2<CR>==gi', { desc = 'Move lines up one' })

-- Run vimscript
vim.cmd([[
  " The marks do not appear to be set before the action in vim.keymap.set(), so leave them here
  vnoremap <A-j> :m '>+1<CR>gv=gv
  vnoremap <A-k> :m '<-2<CR>gv=gv

  " Keep visual selection when indenting
  vnoremap < <gv
  vnoremap > >gv

  highlight eolSpace ctermbg=238 guibg=#e6e6e6 guifg=#bbbbbb
  match eolSpace /\s\+$/
  highlight Folded guibg=#eeeef5 guifg=#aaaaaa
]])

-- Window resizing
vim.keymap.set('n', '<M-,>', [[3<C-W><]], { desc = 'Make split narrower' })
vim.keymap.set('n', '<M-.>', [[3<C-W>>]], { desc = 'Make split wider' })
vim.keymap.set('n', '<M-m>', [[3<C-W>+]], { desc = 'Make split higher' })
vim.keymap.set('n', '<M-/>', [[3<C-W>-]], { desc = 'Make split shorter' })

----- Large navigation
vim.keymap.set('n', '<leader>hi', function()
  local editpath = vim.fn.stdpath('config') .. '/lua/plugins/general.lua'
  vim.cmd.tabedit(editpath)
  vim.cmd.tcd(vim.fn.stdpath('config'))
  require('telescope.builtin').find_files()
end, { desc = 'Edit neovim config in a new tab' })

vim.keymap.set('n', '<leader>s.', function()
  vim.cmd.tabedit('~/.dotfiles/setup.sh')
  vim.cmd.tcd('%:h')
  require('telescope.builtin').find_files()
end, { desc = 'Edit dotfiles in a new tab' })

vim.keymap.set('n', '<leader>sj', function()
  local jaipath = '~/opt/jai'
  vim.cmd.tabedit(jaipath .. '/modules/Basic/Print.jai')
  vim.cmd.tcd(jaipath)
  -- require('telescope.builtin').find_files()
end, { desc = 'Open Jai path' })

----- Misc
-- Toggle error format for boost::test
vim.keymap.set('n', '<leader>T', (function()
  local format = '%f(%l):%.%# error: in %m'
  local last = nil
  return function()
    local newformat
    if last == nil then
      newformat = format
      last = vim.o.errorformat
      -- vim.opt.errorformat:get() does not work
    else
      newformat = last
      last = nil
    end
    print(string.format("vim.opt.errorformat = %q", newformat))
    vim.opt.errorformat = newformat
  end
end)(), { desc = "Set errorformat for boost::test" })
