return {
  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    event = 'VeryLazy',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      {
        'L3MON4D3/LuaSnip',
        build = (function()
          -- Build Step is needed for regex support in snippets
          -- This step is not supported in many windows environments
          -- Remove the below condition to re-enable on windows
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
      },
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      'rafamadriz/friendly-snippets',
      'onsails/lspkind.nvim',
    },
    config = function()
      local cmp = require('cmp')
      local luasnip = require('luasnip')
      local lspkind = require('lspkind') -- Symbols on the completion menu
      require('luasnip.loaders.from_vscode').lazy_load()
      luasnip.config.setup {}

      local next_snippet_node = function(fallback)
        if luasnip.expand_or_locally_jumpable() then
          luasnip.expand_or_jump()
        else
          -- fallback() -- I don't want to add ^L and ^H deletes
        end
      end

      local prev_snippet_node = function(fallback)
        if luasnip.locally_jumpable(-1) then
          luasnip.jump(-1)
        else
          -- fallback() -- I don't want to add ^L and ^H deletes
        end
      end

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert {
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete {},
          ['<C-y>'] = cmp.mapping.confirm {
            select = true,
          },
          ['<C-l>'] = cmp.mapping(next_snippet_node, { 'i', 's' }),
          ['<C-h>'] = cmp.mapping(prev_snippet_node, { 'i', 's' }),
        },
        sources = {
          { name = 'nvim_lsp_signature_help' }, -- show the parameter type and name when inserting
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'path' },
          { name = 'buffer' },
          { name = 'lazydev', group_index = 0 }, -- group_index 0 skips loading LuaLS completions
        },
        formatting = {
          format = lspkind.cmp_format({
            menu = {
              nvim_lsp_signature_help = "[Sig]",
              nvim_lsp = "[LSP]",
              luasnip = "[LuaSnip]",
              path = "[Path]",
              buffer = "[Buffer]",
              lazydev = "[Lazydev]",
            },
          }),
          fields = { 'abbr', 'kind', 'menu' },
          expandable_indicator = true,
        },
      }
    end,
  },
}
