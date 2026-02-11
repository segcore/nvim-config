return {
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',

  {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    event = 'VeryLazy',
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add          = { text = '+' },
        change       = { text = '~' },
        delete       = { text = '×' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
        untracked    = { text = '┆' },
      },
      -- diff_opts = {
      --   algorithm = 'minimal',
      --   linematch = 60,
      -- },
      on_attach = function(bufnr)
        local gs = require('gitsigns')
        local function get_selected_line_range()
          return { vim.fn.line("v"), vim.fn.line(".") }
        end
        local function stage_selected()
          gs.stage_hunk(get_selected_line_range())
        end
        vim.keymap.set('n', '<leader>gp', gs.preview_hunk, { buffer = bufnr, desc = 'Preview git hunk' })
        vim.keymap.set('n', '<leader>gs', gs.stage_hunk, { desc = 'Stage git hunk' })
        vim.keymap.set('v', '<leader>gs', stage_selected, { desc = 'Stage git hunk in selection' })
        vim.keymap.set('n', '<leader>gS', gs.undo_stage_hunk, { desc = 'Undo stage git hunk' })
        vim.keymap.set('n', '<leader>gr', gs.reset_hunk, { buffer = bufnr, desc = 'Reset git hunk' })
        vim.keymap.set('n', '<leader>gA', gs.stage_buffer, { buffer = bufnr, desc = 'Stage file' })
        vim.keymap.set('n', '<leader>gU', gs.reset_buffer_index, { buffer = bufnr, desc = 'Unstage file' })
        vim.keymap.set('n', '<leader>gR', gs.reset_buffer, { buffer = bufnr, desc = 'Reset file' })
        vim.keymap.set('n', '<leader>gd', gs.toggle_deleted, { buffer = bufnr, desc = 'Toggle showing deleted content' })
        vim.keymap.set('n', '<leader>gb', gs.toggle_current_line_blame,
          { buffer = bufnr, desc = 'Toggle git blame current line' })
        vim.keymap.set('n', '<leader>gl', gs.toggle_linehl, { buffer = bufnr, desc = 'Toggle line highlight' })
        vim.keymap.set('n', '<leader>gw', gs.toggle_word_diff, { buffer = bufnr, desc = 'Toggle word diff' })
        vim.keymap.set('n', '<leader>gv', gs.select_hunk, { buffer = bufnr, desc = 'Select git hunk' })
        vim.keymap.set('n', '<leader>gc', function()
          vim.ui.input({ prompt = 'Compare against which revision? ' },
            function(ans)
              if ans == nil then return end -- User cancelled
              if ans == '' then ans = nil end -- Select default current revision
              gs.change_base(ans, true)
            end
          )
        end, { buffer = bufnr, desc = 'Change git diff base to diff against' })

        -- don't override the built-in and fugitive keymaps
        vim.keymap.set({ 'n', 'v' }, ']c', function()
          if vim.wo.diff then
            return ']c'
          end
          vim.schedule(function()
            gs.next_hunk()
          end)
          return '<Ignore>'
        end, { expr = true, buffer = bufnr, desc = 'Jump to next hunk' })
        vim.keymap.set({ 'n', 'v' }, '[c', function()
          if vim.wo.diff then
            return '[c'
          end
          vim.schedule(function()
            gs.prev_hunk()
          end)
          return '<Ignore>'
        end, { expr = true, buffer = bufnr, desc = 'Jump to previous hunk' })
      end,
    },
  },

  'kdheepak/lazygit.nvim',
}
