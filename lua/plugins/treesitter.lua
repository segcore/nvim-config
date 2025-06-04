return {
  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
      {
        'nvim-treesitter/nvim-treesitter-context',
        config = function()
          require('treesitter-context').setup({
            enable = false,
            max_lines = 15,
            -- min_window_height = 25,
            multiline_threshold = 1,
            trim_scope = 'inner',
          })

          vim.keymap.set('n', '<leader>cc', '<cmd>TSContextToggle<CR>', { desc = 'Function context toggle' })

          vim.cmd([[
          hi TreesitterContext guibg=#dde0dd
          hi TreesitterContextLineNumberBottom gui=underline
          ]])
        end,
      }
    },
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs',
    opts = {
      modules = {},
      sync_install = false,
      ignore_install = {},

      -- Add languages to be installed here that you want installed for treesitter
      ensure_installed = {
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
      },

      -- Autoinstall languages that are not installed.
      auto_install = false,

      highlight = { enable = true },
      indent = { enable = true, disable = { 'c', 'cpp' } },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<C-space>',
          node_incremental = '<C-space>',
          scope_incremental = '<C-s>',
          node_decremental = '<M-space>',
        },
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ['aa'] = '@parameter.outer',
            ['ia'] = '@parameter.inner',
            ['af'] = '@function.outer',
            ['if'] = '@function.inner',
            ['ac'] = '@call.outer',
            ['ic'] = '@call.inner',
            ['al'] = '@loop.outer',
            ['il'] = '@loop.inner',
            ['in'] = '@number.inner',
            ['an'] = '@number.inner', -- There is no number.outer
            ['ib'] = '@block.inner',
            ['ab'] = '@block.outer',
            ['ir'] = '@return.inner',
            ['ar'] = '@return.outer',
            ['iv'] = '@conditional.inner',
            ['av'] = '@conditional.outer',
          },
        },
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            [']a'] = '@parameter.inner',
            [']m'] = '@function.outer',
            [']]'] = '@class.outer',
            [']l'] = '@loop.outer',
            [']b'] = '@block.outer',
            [']r'] = '@return.outer',
            [']n'] = '@number.inner',
            [']v'] = '@conditional.inner',
          },
          goto_next_end = {
            [']A'] = '@parameter.outer',
            [']M'] = '@function.outer',
            [']['] = '@class.outer',
            [']L'] = '@loop.outer',
            [']B'] = '@block.outer',
            [']R'] = '@return.outer',
            [']N'] = '@number.inner',
            [']V'] = '@conditional.inner',
          },
          goto_previous_start = {
            ['[a'] = '@parameter.inner',
            ['[m'] = '@function.outer',
            ['[['] = '@class.outer',
            ['[l'] = '@loop.outer',
            ['[b'] = '@block.outer',
            ['[r'] = '@return.outer',
            ['[n'] = '@number.inner',
            ['[v'] = '@conditional.outer',
          },
          goto_previous_end = {
            ['[A'] = '@parameter.outer',
            ['[M'] = '@function.outer',
            ['[]'] = '@class.outer',
            ['[L'] = '@loop.outer',
            ['[B'] = '@block.outer',
            ['[R'] = '@return.outer',
            ['[N'] = '@number.inner',
            ['[V'] = '@conditional.outer',
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ['<leader>a'] = '@parameter.inner',
          },
          swap_previous = {
            ['<leader>A'] = '@parameter.inner',
          },
        },
      },
    },
    config = function(_, opts)
      local parser_config = require('nvim-treesitter.parsers').get_parser_configs()

      if vim.fn.filereadable(vim.fn.expand('~/opt/tree-sitter-jai/src/parser.c')) then
        parser_config.jai = {
          install_info = {
            -- https://github.com/constantitus/tree-sitter-jai
            url = '~/opt/tree-sitter-jai',
            files = { 'src/parser.c', 'src/scanner.c' },
            generate_requires_npm = false,
            requires_generate_from_grammar = false,
          },
          filetype = 'jai',
        }
        vim.treesitter.language.register('jai', 'jai')
        vim.filetype.add({ extension = { jai = "jai", } })
        require('nvim-treesitter.configs').setup(opts)
      end
    end,
  },
}
