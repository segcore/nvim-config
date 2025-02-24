
return {
  {
    'nvim-telescope/telescope.nvim',
    event = 'VeryLazy',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      require('telescope').setup {
        defaults = {
          layout_strategy = 'flex',
          layout_config = {
            height = 9999, -- use maximum height
            width = 0.85,
            horizontal = {
              preview_cutoff = 100,
              prompt_position = "bottom",
            },
            vertical = {
              preview_cutoff = 40,
              prompt_position = "bottom",
            },
            flex = {
              flip_columns = 120,
            },
          },
          use_less = false,
          mappings = {
            i = {
              ["<C-j>"] = require('telescope.actions').cycle_history_next,
              ["<C-k>"] = require('telescope.actions').cycle_history_prev,
            },
          },
          file_ignore_patterns = { '^.git/' },
        },
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown({ layout_config = { width = 130 } }),
          },
        },
      }

      -- Enable telescope fzf native, if installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      -- Wrap the function and call it with the options
      local function ww(func, opts)
        return function() func(opts) end
      end
      local bi = require('telescope.builtin')

      vim.keymap.set('n', '<leader>?', ww(bi.oldfiles, { sort_mru = true }), { desc = '[?] Find recently opened files' })
      vim.keymap.set('n', '<leader><leader>', bi.buffers, { desc = '[ ] Find existing buffers' })

      vim.keymap.set('n', '<leader>/', ww(bi.current_buffer_fuzzy_find, {
        winblend = 10,
        layout_config = { height = 0.8 },
      }), { desc = '[/] Fuzzily search in current buffer' })

      vim.keymap.set('n', '<leader>gt', bi.git_status, { desc = 'Telescope: git status' })
      vim.keymap.set('n', '<leader>gT', ww(bi.git_status, { cwd = vim.fs.dirname(vim.api.nvim_buf_get_name(0)), use_git_root = false }), { desc = 'Telescope: git status' })
      vim.keymap.set('n', '<leader>gB', bi.git_branches, { desc = 'Telescope: git branches' })
      vim.keymap.set('n', '<leader>gf', bi.git_files, { desc = 'Search [G]it [F]iles' })
      vim.keymap.set('n', '<leader>sf', ww(bi.find_files, { hidden = true }), { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>sF', ww(bi.find_files,
          { prompt_title = 'Find All Files', hidden = true, no_ignore = true, no_ignore_parent = true }),
        { desc = '[S]earch [F]iles, include ignored' })
      vim.keymap.set('n', '<leader>sh', bi.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', bi.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sc', ww(bi.colorscheme, { enable_preview = true }), { desc = '[S]earch [C]olourscheme' })
      vim.keymap.set('n', '<leader>sw', ww(bi.grep_string, { additional_args = { '--hidden' } }),
        { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>ss', bi.treesitter, { desc = '[S]earch tree-sitter [S]ymbols' })
      vim.keymap.set('n', '<leader>sm', ww(bi.man_pages, { sections = { "ALL" } }), { desc = '[S]earch [M]an-pages' })
      vim.keymap.set('n', '<leader>sg', ww(bi.live_grep, { additional_args = { '--hidden', '-g', '!\\.git' } }), { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sG', ww(bi.live_grep,
          { prompt_title = 'Live Grep (case sensitive)', additional_args = { '--hidden', '--case-sensitive' } }),
        { desc = '[S]earch by [G]rep (case sensitive)' })
      vim.keymap.set('n', '<leader>sa', ww(bi.live_grep,
          { prompt_title = 'Live Grep all files', additional_args = { '--hidden', '--no-ignore' } }),
        { desc = '[S]earch [A]ll files by grep' })
      vim.keymap.set('n', '<leader>sd', bi.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', bi.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s"', bi.registers, { desc = '[S]earch registers' })
      vim.keymap.set('n', '<leader>sj', bi.jumplist, { desc = '[S]earch [J]umplist' })
      vim.keymap.set('n', '<leader>sT', bi.tagstack, { desc = '[S]earch [T]agstack' })
      vim.keymap.set('n', '<leader>sq', bi.quickfix, { desc = '[S]earch [Q]uickfix list' })
      vim.keymap.set('n', '<leader>sQ', bi.quickfixhistory, { desc = '[S]earch [Q]uickfix history' })
      vim.keymap.set('n', '<leader>sl', bi.loclist, { desc = '[S]earch [L]ocation list' })
      vim.keymap.set('n', '<leader>st', bi.builtin, { desc = '[S]earch [T]elescope' })
      vim.keymap.set('n', '<leader>si', ww(bi.find_files, { cwd = vim.fn.stdpath('config') }),
        { desc = '[S]earch neovim configuration' })
      vim.keymap.set('n', '<leader>s/', ww(bi.live_grep, {
        prompt_title = 'Live Grep in Open Files',
        grep_open_files = true,
      }), { desc = '[S]earch [/] in Open Files' })
    end
  },
}
