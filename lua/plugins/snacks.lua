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
        vim.keymap.set('n', '<leader>e', function() snacks.picker.explorer() end, { desc = 'Open file explorer' })

        vim.keymap.set('n', '<leader>?', function() snacks.picker.recent() end, { desc = 'Find recently opened files' })
        vim.keymap.set('n', '<leader><leader>', function() snacks.picker.buffers() end, { desc = 'Find open buffers' })
        vim.keymap.set('n', '<leader>/', function() snacks.picker.lines() end, { desc = 'Search buffer lines' })

        vim.keymap.set('n', '<leader>gt', function() snacks.picker.git_status() end, { desc = 'Telescope: git status' })
        -- vim.keymap.set('n', '<leader>gT', ww(bi.git_status, { cwd = vim.fs.dirname(vim.api.nvim_buf_get_name(0)), use_git_root = false }), { desc = 'Telescope: git status' })
        vim.keymap.set('n', '<leader>gB', function() snacks.picker.git_branches() end, { desc = 'Telescope: git branches' })
        vim.keymap.set('n', '<leader>gf', function() snacks.picker.git_files() end, { desc = 'Search [G]it [F]iles' })
        vim.keymap.set('n', '<leader>sf', function() snacks.picker.files() end, { desc = '[S]earch [F]iles' })
        vim.keymap.set('n', '<leader>sF', function() snacks.picker.smart() end, { desc = 'Smart files picker' })
        vim.keymap.set('n', '<leader>sh', function() snacks.picker.help() end, { desc = '[S]earch [H]elp' })
        vim.keymap.set('n', '<leader>sk', function() snacks.picker.keymaps() end, { desc = '[S]earch [K]eymaps' })
        vim.keymap.set('n', '<leader>sc', function() snacks.picker.colorschemes() end, { desc = '[S]earch [C]olourscheme' })
        vim.keymap.set('n', '<leader>sw', function() snacks.picker.grep_word() end, { desc = '[S]earch current [W]ord' })
        vim.keymap.set('n', '<leader>ss', function() snacks.picker.treesitter() end, { desc = '[S]earch tree-sitter [S]ymbols' })
        vim.keymap.set('n', '<leader>sm', function() snacks.picker.man() end, { desc = '[S]earch [M]an-pages' })
        vim.keymap.set('n', '<leader>sg', function() snacks.picker.grep() end, { desc = '[S]earch by [G]rep' })

        -- TODO: Grep, but case sensitive
        vim.keymap.set('n', '<leader>sG', function() snacks.picker.git_grep() end, { desc = '[S]earch by git [G]rep' })
        -- TODO: Grep, but show all files
        vim.keymap.set('n', '<leader>sa', function() snacks.picker.grep() end, { desc = '[S]earch [A]ll files by grep' })

        vim.keymap.set('n', '<leader>sd', function() snacks.picker.diagnostics() end, { desc = '[S]earch [D]iagnostics' })
        vim.keymap.set('n', '<leader>sr', function() snacks.picker.resume() end, { desc = '[S]earch [R]esume' })
        vim.keymap.set('n', '<leader>s"', function() snacks.picker.registers() end, { desc = '[S]earch registers' })
        vim.keymap.set('n', '<leader>sj', function() snacks.picker.jumps() end, { desc = '[S]earch [J]umplist' })
        -- vim.keymap.set('n', '<leader>sT', function() snacks.picker.tags() end, { desc = '[S]earch [T]agstack' })
        vim.keymap.set('n', '<leader>sq', function() snacks.picker.qflist() end, { desc = '[S]earch [Q]uickfix list' })
        -- vim.keymap.set('n', '<leader>sQ', function() snacks.picker.qflist_history() end, { desc = '[S]earch [Q]uickfix history' })
        vim.keymap.set('n', '<leader>sl', function() snacks.picker.loclist() end, { desc = '[S]earch [L]ocation list' })
        vim.keymap.set('n', '<leader>st', function() snacks.picker.pickers() end, { desc = '[S]earch [T]elescope' })
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
