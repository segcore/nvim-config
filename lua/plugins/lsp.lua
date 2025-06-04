return {
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Useful status updates for LSP
      { 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },

      -- Lua LS support
      {
        'folke/lazydev.nvim',
        ft = 'lua',
        opts = {
          library = {
            'luvit-meta/library',
          },
        },
        dependencies = {
          { 'Bilal2453/luvit-meta', lazy = true}, -- vim.uv types
        },
      }
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.server_capabilities.documentHighlightProvider then
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              callback = vim.lsp.buf.clear_references,
            })
          end
        end,
      })

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      --  Add any additional override configuration in the following tables. Available keys are:
      --  - cmd (table): Override the default command used to start the server
      --  - filetypes (table): Override the default list of associated filetypes for the server
      --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
      --  - settings (table): Override the default settings passed when initializing the server.
      --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
      local servers = {
        clangd = {
          filetypes = {
            "c", "cpp", "objc", "objcpp", "cuda"
          },
        },
        ols = {},
        -- gopls = {},
        pylsp = {
          settings = {
            pylsp = {
              plugins = {
                pycodestyle = {
                  ignore = {'W391', 'E302', 'E303', 'E266', 'E261' },
                  maxLineLength = 200,
                },
              },
            },
          },
        },
        -- pylyzer = {
        -- },
        -- csharp_ls = {},
        -- ["omnisharp-mono"] = {},
        -- ["omnisharp_mono"] = {},
        -- omnisharp = {
        --   enable_import_completion = true,
        --   organize_imports_on_format = true,
        --   enable_roslyn_analyzers = true,
        -- },
        -- rust_analyzer = {},
        -- html = { filetypes = { 'html', 'twig', 'hbs'} },

        -- lua_ls = {
        --   Lua = {
        --     workspace = { checkThirdParty = false },
        --     telemetry = { enable = false },
        --   },
        -- },

        lua_ls = {
          -- cmd = {...},
          -- filetypes { ...},
          -- capabilities = {},
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
              -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
              -- diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },
      }


      require('mason').setup()


      local ensure_installed = vim.tbl_keys(servers)
      vim.list_extend(ensure_installed, {
        'stylua', -- Format lua code
      })
      require('mason-tool-installer').setup({ ensure_installed = ensure_installed })

      local on_attach = function(_, bufnr)
        -- Create a command `:Format` local to the LSP buffer
        vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
          vim.lsp.buf.format()
        end, { desc = 'Format current buffer with LSP' })
      end

      require('mason-lspconfig').setup({
        handlers = {
          function(server_name)
            local server = require('lspconfig')[server_name]
            if server and server.setup then
              local settings = servers[server_name] or {}
              settings.capabilities = vim.tbl_deep_extend('force', {}, capabilities, settings.capabilities or {})
              settings.on_attach = settings.on_attach or on_attach
              server.setup(settings)
            else
              print("Unhandled server " .. server_name)
            end
          end,
        },
      })
    end
  },
}
