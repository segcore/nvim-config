return {
  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  -- Navigate between tmux panes with ctrl-h/j/k/l
  'christoomey/vim-tmux-navigator',
  'terrastruct/d2-vim',
  'aklt/plantuml-syntax',
  'ThePrimeagen/vim-be-good',

  -- Run stuff in the background like :Make. :Copen to see the results
  'tpope/vim-dispatch',

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },

  -- Surround [selection/motion] in quotes/<tags>, and delete surrounding ..
  -- add: ysiw"   delete:  ds"    change:  cs"'
  { "kylechui/nvim-surround", opts = {} },

  -- Jump to last position when re-opening file
  { 'ethanholz/nvim-lastplace', opts = {} },

  {
    'brenoprata10/nvim-highlight-colors',
    opts = {
      enable_short_hex = false,
    },
  },

  { -- Welcome screen
    'goolord/alpha-nvim',
    config = function()
      require('alpha').setup(require('alpha.themes.startify').config)
    end,
  },

  { -- Rewrite with sudo
    'lambdalisue/suda.vim',
    event = 'VeryLazy',
  },

  { -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    event = 'VeryLazy',
    -- See `:help ibl`
    main = 'ibl',
    opts = {},
    enabled = false,
  },

  {
    'roman/golden-ratio',
    init = function()
      vim.g.golden_ratio_autocommand = 0
      vim.keymap.set('n', '<C-w>-', '<Plug>(golden_ratio_resize)<CR>', { desc = "Resize windows to the golden ratio "})
      vim.keymap.set('n', '<C-w>0', ':GoldenRatioToggle<CR>', { desc = "Toggle automatic window resizing"})
    end,
  },

  { -- status line
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    opts = {
      options = {
        icons_enabled = true,
        theme = 'catppuccin',
        component_separators = '|',
        section_separators = '',
      },
      sections = {
        lualine_c = {
          { 'filename', path = 1 },
        },
        lualine_x = { 'filesize', 'encoding', 'fileformat', 'filetype' },
        lualine_z = { 'selectioncount', 'location' }
      },
    },
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    }
  },

  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    config = function()
      require('which-key').setup({
        spec = {
          { "<leader>g",  group = "[G]it" },
          { "<leader>h",  group = "[H]arpoon" },
          { "<leader>s",  group = "[S]earch" },
          { "<leader>w",  group = "[W]orkspace" },
        },
      })
    end,
  },

  {
    'mbbill/undotree',
    event = 'VeryLazy',
    config = function()
      vim.g.undotree_WindowLayout = 3 -- right side
      vim.g.undotree_SetFocusWhenToggle = 1
      vim.g.undotree_SplitWidth = 40
      vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)
    end,
  },

  -- Jump to earlier files
  {
    'ThePrimeagen/harpoon',
    event = 'VeryLazy',
    dependencies = {
      'nvim-lua/plenary.nvim'
    },
    opts = {
      menu = {
        width = 100,
      }
    },
    config = function()
      vim.keymap.set('n', '<leader>ha', require('harpoon.mark').add_file, { desc = 'Harpoon: [a]dd file' })
      vim.keymap.set('n', '<leader>hs', require('harpoon.ui').toggle_quick_menu, { desc = 'Harpoon: [s]how UI' })
      vim.keymap.set('n', '<leader>hj', require('harpoon.ui').nav_next, { desc = 'Harpoon: next mark' })
      vim.keymap.set('n', '<leader>hk', require('harpoon.ui').nav_prev, { desc = 'Harpoon: prev mark' })
      vim.keymap.set('n', '<leader>hq', function() require('harpoon.ui').nav_file(1) end, { desc = 'Harpoon: file 1' })
      vim.keymap.set('n', '<leader>hw', function() require('harpoon.ui').nav_file(2) end, { desc = 'Harpoon: file 2' })
      vim.keymap.set('n', '<leader>he', function() require('harpoon.ui').nav_file(3) end, { desc = 'Harpoon: file 3' })
      vim.keymap.set('n', '<leader>hr', function() require('harpoon.ui').nav_file(4) end, { desc = 'Harpoon: file 4' })
    end,
  },

  -- File browser
  {
    'nvim-tree/nvim-tree.lua',
    event = 'VeryLazy',
    dependencies = {
      'nvim-tree/nvim-web-devicons'
    },
    opts = {
      view = {
        side = "right",
        width = 43,
        preserve_window_proportions = true,
      },
      filters = {
        git_ignored = false,
      },
      actions = {
        open_file = {
          quit_on_open = true,
          resize_window = false,
          window_picker = { enable = false },
        },
      },
    },
    config = function(_, opts)
      require('nvim-tree').setup(opts)
      vim.keymap.set('n', '-', function()
        require("nvim-tree.api").tree.toggle({ path = ".", find_file = true, focus = true })
      end, { desc = 'Toggle nvim-tree view' })
    end,
  },

  {
    'iamcco/markdown-preview.nvim',
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown", "plantuml" },
    build = function() vim.fn["mkdp#util#install"]() end,
    init = function()
      if vim.g.is_wsl then
        vim.cmd([[
          function OpenMarkdownPreview (url)
            execute "silent ! wslview " . a:url
          endfunction
          let g:mkdp_browserfunc = 'OpenMarkdownPreview'
          let g:mkdp_command_for_global = 1
        ]])
      end
    end,
  },

  -- Put-text extensions.
  -- e.g. Paste with previous/next register keymaps (active after the text is pasted)
  {
    'gbprod/yanky.nvim',
    config = function()
      require('yanky').setup({
        ring = {
          history_length = 20,
        },
        system_clipboard = {
          sync_with_ring = false, -- Sync takes a little time
        },
        highlight = {
          on_put = false,
          on_yank = false,
          timer = 100,
        },
        textobj = { -- yanky.last_put() text object
          enabled = false,
        },
      })

      vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
      vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")
      vim.keymap.set({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)")
      vim.keymap.set({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)")

      vim.keymap.set("n", "<C-p>", "<Plug>(YankyPreviousEntry)")
      vim.keymap.set("n", "<C-n>", "<Plug>(YankyNextEntry)")

      -- Linewise put before and after
      vim.keymap.set("n", "]p", "<Plug>(YankyPutIndentAfterLinewise)", { desc = 'Put after line' })
      vim.keymap.set("n", "]P", "<Plug>(YankyPutIndentAfterLinewise)", { desc = 'Put after line' })
      vim.keymap.set("n", "[p", "<Plug>(YankyPutIndentBeforeLinewise)", { desc = 'Put before line' })
      vim.keymap.set("n", "[P", "<Plug>(YankyPutIndentBeforeLinewise)", { desc = 'Put before line' })

      -- These only work if you're quick (within 'timeoutlen'). Otherwise it enters operator-pending mode.
      vim.keymap.set("n", ">p", "<Plug>(YankyPutIndentAfterShiftRight)", { desc = 'Put after, indent >' })
      vim.keymap.set("n", "<p", "<Plug>(YankyPutIndentAfterShiftLeft)", { desc = 'Put after, indent <' })
      vim.keymap.set("n", ">P", "<Plug>(YankyPutIndentBeforeShiftRight)", { desc = 'Put before, indent >' })
      vim.keymap.set("n", "<P", "<Plug>(YankyPutIndentBeforeShiftLeft)", { desc = 'Put before, indent <' })
      vim.keymap.set("n", "=p", "<Plug>(YankyPutAfterFilter)", { desc = 'Put after, indent auto' })
      vim.keymap.set("n", "=P", "<Plug>(YankyPutBeforeFilter)", { desc = 'Put before, indent auto' })
    end,
  },

  {
    'amitds1997/remote-nvim.nvim',
    enabled = false,
    version = "*",                     -- Pin to GitHub releases
    dependencies = {
      "nvim-lua/plenary.nvim",         -- For standard functions
      "MunifTanjim/nui.nvim",          -- To build the plugin UI
      "nvim-telescope/telescope.nvim", -- For picking b/w different remote methods
    },
    config = true,
    build = function()
      local devpod = vim.fn.exepath('devpod')
      if not devpod then
        print('NOTE: remote-nvim requires devpod for devcontainers')
      end
    end,
  },

  {
    'github/copilot.vim',
    event = 'VeryLazy',
    init = function()
      vim.g.copilot_enabled = true
    end,
  },
}
