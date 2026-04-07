return {
  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    build = ':TSUpdate',
    setup = function()
      -- todo, use this
      local ensure_installed = {
        'asm',
        'awk',
        'bash',
        'bitbake',
        'c',
        'cmake',
        'cpp',
        'css',
        -- 'csv',
        'diff',
        'dockerfile',
        'dot',
        'git_config',
        'git_rebase',
        'gitattributes',
        'gitcommit',
        'gitignore',
        'go',
        'haskell',
        'html',
        'ini',
        'java',
        'javascript',
        'jq',
        'jsdoc',
        'json',
        'json5',
        'jsonc',
        'kotlin',
        'lua',
        'luadoc',
        'make',
        'markdown',
        'ninja',
        'ocaml',
        'odin',
        'passwd',
        'php',
        'printf',
        'proto',
        'regex',
        'rust',
        'sql',
        'ssh_config',
        'strace',
        'tmux',
        'toml',
        'typescript',
        'vim',
        'vimdoc',
        'xml',
        'yaml',
        'zig',
      }
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',
    init = function()
      -- Suggested to avoid conflicts, but this sounds bad
      -- vim.g.no_plugin_maps = true
    end,
    config = function()
      require("nvim-treesitter-textobjects").setup {
        select = {
          lookahead = true,
          selection_modes = {
            ['@parameter.outer'] = 'v', -- charwise
            ['@function.outer'] = 'V', -- linewise
          },
          include_surrounding_whitespace = false,
        },
        move = {
          set_jumps = true,
        }
      }

      local select = function(lhs, query_string, query_group)
        vim.keymap.set({'x', 'o'}, lhs, function()
          require("nvim-treesitter-textobjects.select").select_textobject(query_string, query_group)
        end)
      end
      local swap_prev = function(lhs, query_string, query_group)
        vim.keymap.set('n', lhs, function()
          require("nvim-treesitter-textobjects.swap").swap_previous(query_string, query_group)
        end)
      end
      local swap_next = function(lhs, query_string, query_group)
        vim.keymap.set('n', lhs, function()
          require("nvim-treesitter-textobjects.swap").swap_next(query_string, query_group)
        end)
      end
      local goto_next_start = function(lhs, query_string, query_group)
        vim.keymap.set({'n', 'x', 'o'}, lhs, function()
          require("nvim-treesitter-textobjects.move").goto_next_start(query_string, query_group)
        end)
      end
      local goto_next_end = function(lhs, query_string, query_group)
        vim.keymap.set({'n', 'x', 'o'}, lhs, function()
          require("nvim-treesitter-textobjects.move").goto_next_end(query_string, query_group)
        end)
      end
      local goto_previous_start = function(lhs, query_string, query_group)
        vim.keymap.set({'n', 'x', 'o'}, lhs, function()
          require("nvim-treesitter-textobjects.move").goto_previous_start(query_string, query_group)
        end)
      end
      local goto_previous_end = function(lhs, query_string, query_group)
        vim.keymap.set({'n', 'x', 'o'}, lhs, function()
          require("nvim-treesitter-textobjects.move").goto_previous_end(query_string, query_group)
        end)
      end

      select('aa', '@parameter.outer', 'textobjects')
      select('ia', '@parameter.inner', 'textobjects')
      select('af', '@function.outer', 'textobjects')
      select('if', '@function.inner', 'textobjects')
      select('ac', '@call.outer', 'textobjects')
      select('ic', '@call.inner', 'textobjects')
      select('al', '@loop.outer', 'textobjects')
      select('il', '@loop.inner', 'textobjects')
      -- select('in', '@number.inner', 'textobjects')
      -- select('an', '@number.inner', 'textobjects') -- There is no number.outer
      select('ir', '@return.inner', 'textobjects')
      select('ar', '@return.outer', 'textobjects')
      select('iv', '@conditional.inner', 'textobjects')
      select('av', '@conditional.outer', 'textobjects')
      swap_next('<leader>a', '@parameter.inner')
      swap_prev('<leader>A', '@parameter.outer')

      goto_next_start(']a', '@parameter.inner')
      goto_next_start(']m', '@function.outer')
      goto_next_start(']]', '@class.outer')
      goto_next_start(']l', '@loop.outer')
      goto_next_start(']r', '@return.outer')
      goto_next_start(']n', '@number.inner')
      goto_next_start(']v', '@conditional.inner')

      goto_next_end(']A', '@parameter.outer')
      goto_next_end(']M', '@function.outer')
      goto_next_end('][', '@class.outer')
      goto_next_end(']L', '@loop.outer')
      goto_next_end(']R', '@return.outer')
      goto_next_end(']N', '@number.inner')
      goto_next_end(']V', '@conditional.inner')

      goto_previous_start('[a', '@parameter.inner')
      goto_previous_start('[m', '@function.outer')
      goto_previous_start('[[', '@class.outer')
      goto_previous_start('[l', '@loop.outer')
      goto_previous_start('[r', '@return.outer')
      goto_previous_start('[n', '@number.inner')
      goto_previous_start('[v', '@conditional.outer')

      goto_previous_end('[A', '@parameter.outer')
      goto_previous_end('[M', '@function.outer')
      goto_previous_end('[]', '@class.outer')
      goto_previous_end('[L', '@loop.outer')
      goto_previous_end('[R', '@return.outer')
      goto_previous_end('[N', '@number.inner')
      goto_previous_end('[V', '@conditional.outer')

--       -- indent = { enable = true, disable = { 'c', 'cpp' } },
--       incremental_selection = {
--         enable = true,
--         keymaps = {
--           init_selection = '<C-space>',
--           node_incremental = '<C-space>',
--           scope_incremental = '<C-s>',
--           node_decremental = '<M-space>',
--         },
--       },

    end,
  },

  {
    'nvim-treesitter/nvim-treesitter-context',
    config = function()
      require('treesitter-context').setup({
        max_lines = 6,
        -- min_window_height = 25,
        multiline_threshold = 1,
        trim_scope = 'inner',
      })

      vim.keymap.set('n', '<leader>cc', '<cmd>TSContext toggle<CR>', { desc = 'Function context toggle' })

      vim.cmd([[
      hi TreesitterContext guibg=#dde0dd
      hi TreesitterContextLineNumberBottom gui=underline
      ]])
    end,
  },
}
