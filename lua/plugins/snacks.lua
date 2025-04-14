return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      bigfile = {
        enabled = true,
        notify = false,
      },
      bufdelete = { enabled = true },
      -- dashboard = { enabled = true },
      debug = { enabled = true },
      -- dim = { enabled = true },
      explorer = { enabled = true },
      git = { enabled = true },
      gitbrowse = { enabled = true },
      -- image = { enabled = true },
      -- indent = { enabled = true },
      -- input = { enabled = true },
      -- layout = { enabled = true },
      lazygit = { enabled = true },
      -- notifier = { enabled = true },
      -- notify = { enabled = true },
      picker = {
        ui_select = false,
        matcher = {
          fuzzy = true,
          smartcase = true,
          ignorecase = false,
          sort_empty = false, -- Dodgy
          history_bonus = false,
          frecency = false,
        },
        formatters = {
          file = {
            truncate = 70,
          },
        },
      },
      profiler = { enabled = true },
      -- quickfile = { enabled = true },
      rename = { enabled = true },
      -- scope = { enabled = true },
      -- scratch = { enabled = true },
      -- scroll = { enabled = true },
      -- statuscolumn = { enabled = true },
      -- terminal = { enabled = true },
      toggle = { enabled = true },
      -- win = { enabled = true },
      -- words = { enabled = true },
      -- zen = { enabled = true },
    },

    config = function(_, opts)
      local snacks = require("snacks")
      snacks.setup(opts)

      if vim.g.picker == 'snacks' then
        -- Sorting is required to make 'resume' work in some pickers.
        -- But it makes other things stop working
        -- Trying to selectively sort and not-sort others seems to break everything.
        local sort = nil
        -- sort = vim.deepcopy(opts.picker)
        -- sort.matcher.sort_empty = true

        vim.keymap.set('n', '<leader>e', function() snacks.picker.explorer() end, { desc = 'Open file explorer' })

        vim.keymap.set('n', '<leader>?', function() snacks.picker.recent() end, { desc = 'Find recently opened files' })
        vim.keymap.set('n', '<leader><leader>', function() snacks.picker.buffers() end, { desc = 'Find open buffers' })
        vim.keymap.set('n', '<leader>/', function() snacks.picker.lines() end, { desc = 'Search buffer lines' })

        vim.keymap.set('n', '<leader>gt', function() snacks.picker.git_status() end, { desc = 'Git status' })
        -- vim.keymap.set('n', '<leader>gT', ww(bi.git_status, { cwd = vim.fs.dirname(vim.api.nvim_buf_get_name(0)), use_git_root = false }), { desc = 'Telescope: git status' })
        vim.keymap.set('n', '<leader>gB', function() snacks.picker.git_branches() end, { desc = 'Git branches' })
        vim.keymap.set('n', '<leader>gf', function() snacks.picker.git_files(sort) end, { desc = 'Search Git Files' })
        vim.keymap.set('n', '<leader>sf', function() snacks.picker.files(sort) end, { desc = 'Search Files' })
        vim.keymap.set('n', '<leader>sF', function() snacks.picker.smart() end, { desc = 'Smart files picker' })
        vim.keymap.set('n', '<leader>sh', function() snacks.picker.help(sort) end, { desc = 'Search Help' })
        vim.keymap.set('n', '<leader>sk', function() snacks.picker.keymaps(sort) end, { desc = 'Search Keymaps' })
        vim.keymap.set('n', '<leader>sc', function() snacks.picker.colorschemes(sort) end, { desc = 'Search Colourscheme' })
        vim.keymap.set('n', '<leader>sw', function() snacks.picker.grep_word(sort) end, { desc = 'Search current Word' })
        vim.keymap.set('n', '<leader>ss', function() snacks.picker.treesitter() end, { desc = 'Search tree-sitter Symbols' })
        vim.keymap.set('n', '<leader>sm', function() snacks.picker.man(sort) end, { desc = 'Search Man-pages' })
        vim.keymap.set('n', '<leader>sg', function() snacks.picker.grep(sort) end, { desc = 'Search by Grep' })

        -- TODO: Grep, but case sensitive
        vim.keymap.set('n', '<leader>sG', function() snacks.picker.git_grep(sort) end, { desc = 'Search by git Grep' })
        -- TODO: Grep, but show all files
        vim.keymap.set('n', '<leader>sa', function() snacks.picker.grep(sort) end, { desc = 'Search All files by grep' })

        vim.keymap.set('n', '<leader>sd', function() snacks.picker.diagnostics() end, { desc = 'Search Diagnostics' })
        vim.keymap.set('n', '<leader>sr', function() snacks.picker.resume() end, { desc = 'Search Resume' })
        vim.keymap.set('n', '<leader>s"', function() snacks.picker.registers(sort) end, { desc = 'Search registers' })
        vim.keymap.set('n', '<leader>sj', function() snacks.picker.jumps() end, { desc = 'Search Jumplist' })
        -- vim.keymap.set('n', '<leader>sT', function() snacks.picker.tags() end, { desc = 'Search Tagstack' })
        vim.keymap.set('n', '<leader>sq', function() snacks.picker.qflist(sort) end, { desc = 'Search Quickfix list' })
        -- vim.keymap.set('n', '<leader>sQ', function() snacks.picker.qflist_history() end, { desc = 'Search Quickfix history' })
        vim.keymap.set('n', '<leader>sl', function() snacks.picker.loclist(sort) end, { desc = 'Search Location list' })
        vim.keymap.set('n', '<leader>st', function() snacks.picker.pickers(sort) end, { desc = 'Search Telescope' })

        -- LSP things
        vim.keymap.set('n', 'gd', function() snacks.picker.lsp_definitions() end, { desc = 'Goto Definition' })
        vim.keymap.set('n', 'gr', function() snacks.picker.lsp_references() end, { desc = 'Goto References' })
        vim.keymap.set('n', 'gI', function() snacks.picker.lsp_implementations() end, { desc = 'Goto Implementation' })
        vim.keymap.set('n', '<leader>D', function() snacks.picker.lsp_type_definitions() end, { desc = 'Type Definition' })
        vim.keymap.set('n', '<leader>ds', function() snacks.picker.lsp_symbols() end, { desc = 'Document Symbols' })
        vim.keymap.set('n', '<leader>ws', function() snacks.picker.lsp_workspace_symbols() end, { desc = 'Workspace Symbols' })
        vim.keymap.set('n', '<leader>wS', function() snacks.picker.lsp_declarations() end, { desc = 'Workspace Symbols, this workspace' })
      end

      -- Snacks docs suggest to this if using nvim-tree
      local prev = { new_name = "", old_name = "" } -- Prevents duplicate events
      vim.api.nvim_create_autocmd("User", {
        pattern = "NvimTreeSetup",
        callback = function()
          local events = require("nvim-tree.api").events
          events.subscribe(events.Event.NodeRenamed, function(data)
            if prev.new_name ~= data.new_name or prev.old_name ~= data.old_name then
              data = data
              if Snacks then
                Snacks.rename.on_rename_file(data.old_name, data.new_name)
              end
            end
          end)
        end,
      })

    end,
  }
}
