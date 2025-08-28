return {
  {
    'nvim-telescope/telescope.nvim',
    event = 'VeryLazy',
    -- branch = '0.1.x',
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
          path_display = {
            "truncate",
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

      if vim.g.picker == 'telescope' then
      -- Wrap the function and call it with the options
      local function ww(func, opts)
        return function() func(opts) end
      end
      local bi = require('telescope.builtin')

      vim.keymap.set('n', '<leader>?', ww(bi.oldfiles, { sort_mru = true }), { desc = '? Find recently opened files' })
      vim.keymap.set('n', '<leader><leader>', bi.buffers, { desc = '  Find existing buffers' })

      vim.keymap.set('n', '<leader>/', ww(bi.current_buffer_fuzzy_find, {
        winblend = 10,
        layout_config = { height = 0.8 },
      }), { desc = '/ Fuzzily search in current buffer' })

      vim.keymap.set('n', '<leader>gt', bi.git_status, { desc = 'Telescope: git status' })
      vim.keymap.set('n', '<leader>gT', ww(bi.git_status, { cwd = vim.fs.dirname(vim.api.nvim_buf_get_name(0)), use_git_root = false }), { desc = 'Telescope: git status' })
      vim.keymap.set('n', '<leader>gB', bi.git_branches, { desc = 'Telescope: git branches' })
      vim.keymap.set('n', '<leader>gh', bi.git_stash, { desc = 'Telescope: git stash' })
      vim.keymap.set('n', '<leader>gf', bi.git_files, { desc = 'Search Git Files' })
      vim.keymap.set('n', '<leader>sf', ww(bi.find_files, { hidden = true }), { desc = 'Search Files' })
      vim.keymap.set('n', '<leader>sF', ww(bi.find_files,
          { prompt_title = 'Find All Files', hidden = true, no_ignore = true, no_ignore_parent = true }),
        { desc = 'Search Files, include ignored' })
      vim.keymap.set('n', '<leader>sh', bi.help_tags, { desc = 'Search Help' })
      vim.keymap.set('n', '<leader>sk', bi.keymaps, { desc = 'Search Keymaps' })
      vim.keymap.set('n', '<leader>sc', ww(bi.colorscheme, { enable_preview = true }), { desc = 'Search Colourscheme' })
      vim.keymap.set('n', '<leader>sw', ww(bi.grep_string, { additional_args = { '--hidden' } }),
        { desc = 'Search current Word' })
      vim.keymap.set('n', '<leader>ss', bi.treesitter, { desc = 'Search tree-sitter Symbols' })
      vim.keymap.set('n', '<leader>sm', ww(bi.man_pages, { sections = { "ALL" } }), { desc = 'Search Man-pages' })
      vim.keymap.set('n', '<leader>sg', ww(bi.live_grep, { additional_args = { '--hidden', '-g', '!\\.git' } }), { desc = 'Search by Grep' })
      vim.keymap.set('n', '<leader>sG', ww(bi.live_grep,
          { prompt_title = 'Live Grep (case sensitive)', additional_args = { '--hidden', '--case-sensitive' } }),
        { desc = 'Search by Grep (case sensitive)' })
      vim.keymap.set('n', '<leader>sa', ww(bi.live_grep,
          { prompt_title = 'Live Grep all files', additional_args = { '--hidden', '--no-ignore' } }),
        { desc = 'Search All files by grep' })
      vim.keymap.set('n', '<leader>s0', function()
          local dir = vim.fs.dirname(vim.api.nvim_buf_get_name(0))
          bi.live_grep { prompt_title = 'Live Grep in ' .. dir, cwd = dir, additional_args = { '--hidden', '--no-ignore' } }
        end, { desc = 'Search by grep in buf dir' })
      vim.keymap.set('n', '<leader>s1', function()
          local dir = vim.fs.dirname(vim.fs.dirname(vim.api.nvim_buf_get_name(0)))
          bi.live_grep { prompt_title = 'Live Grep in ' .. dir, cwd = dir, additional_args = { '--hidden', '--no-ignore' } }
        end, { desc = 'Search by grep in buf dir-up-1' })
      vim.keymap.set('n', '<leader>sd', bi.diagnostics, { desc = 'Search Diagnostics' })
      vim.keymap.set('n', '<leader>sr', bi.resume, { desc = 'Search Resume' })
      vim.keymap.set('n', '<leader>s"', bi.registers, { desc = 'Search registers' })
      vim.keymap.set('n', '<leader>sJ', bi.jumplist, { desc = 'Search Jumplist' })
      vim.keymap.set('n', '<leader>sT', bi.tagstack, { desc = 'Search Tagstack' })
      vim.keymap.set('n', '<leader>sq', bi.quickfix, { desc = 'Search Quickfix list' })
      vim.keymap.set('n', '<leader>sQ', bi.quickfixhistory, { desc = 'Search Quickfix history' })
      vim.keymap.set('n', '<leader>sl', bi.loclist, { desc = 'Search Location list' })
      vim.keymap.set('n', '<leader>st', bi.builtin, { desc = 'Search Telescope' })
      vim.keymap.set('n', '<leader>si', ww(bi.find_files, { cwd = vim.fn.stdpath('config') }),
        { desc = 'Search neovim configuration' })
      vim.keymap.set('n', '<leader>s/', ww(bi.live_grep, {
        prompt_title = 'Live Grep in Open Files',
        grep_open_files = true,
      }), { desc = 'Search in Open Files' })

      local ws_opts = {
        fname_width = 0.5,
        symbol_width = 0.25,
        symbol_type_width = 0.2,
        path_display = {
          "filename_first",
        },
      }

      vim.keymap.set('n', 'gd', bi.lsp_definitions, { desc = 'Goto Definition' })
      vim.keymap.set('n', 'gr', bi.lsp_references, { desc = 'Goto References' })
      vim.keymap.set('n', 'gI', bi.lsp_implementations, { desc = 'Goto Implementation' })
      vim.keymap.set('n', '<leader>D', bi.lsp_type_definitions, { desc = 'Type Definition' })
      vim.keymap.set('n', '<leader>ds', bi.lsp_document_symbols, { desc = 'Document Symbols' })
      vim.keymap.set('n', '<leader>ws', function() bi.lsp_dynamic_workspace_symbols(ws_opts) end, { desc = 'Workspace Symbols' })
      vim.keymap.set('n', '<leader>wS', function() bi.lsp_workspace_symbols(ws_opts) end, { desc = 'Workspace Symbols, this workspace' })
      end -- vim.g.picker == 'telescope'

    end
  },
}
