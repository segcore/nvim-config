-- Remove default keymaps of nvim 0.11 which conflict
vim.keymap.del('n', 'grn')
vim.keymap.del('n', 'grr')
vim.keymap.del('n', 'gri')
vim.keymap.del('n', 'gra')

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
          local nmap = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
          nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

          if vim.g.picker == 'telescope' then
            local tele = require('telescope.builtin')
            local ws_opts = {
              fname_width = 0.5,
              symbol_width = 0.25,
              symbol_type_width = 0.2,
              path_display = {
                "filename_first",
              },
            }
            nmap('gd', tele.lsp_definitions, '[G]oto [D]efinition')
            nmap('gr', tele.lsp_references, '[G]oto [R]eferences')
            nmap('gI', tele.lsp_implementations, '[G]oto [I]mplementation')
            nmap('<leader>D', tele.lsp_type_definitions, 'Type [D]efinition')
            nmap('<leader>ds', tele.lsp_document_symbols, '[D]ocument [S]ymbols')
            nmap('<leader>ws', function() tele.lsp_dynamic_workspace_symbols(ws_opts) end, '[W]orkspace [S]ymbols')
            nmap('<leader>wS', function() tele.lsp_workspace_symbols(ws_opts) end, '[W]orkspace [S]ymbols, this workspace')
          elseif vim.g.picker == 'snacks' then
            local snacks = require('snacks')
            nmap('gd', function() snacks.picker.lsp_definitions() end, '[G]oto [D]efinition')
            nmap('gr', function() snacks.picker.lsp_references() end, '[G]oto [R]eferences')
            nmap('gI', function() snacks.picker.lsp_implementations() end, '[G]oto [I]mplementation')
            nmap('<leader>D', function() snacks.picker.lsp_type_definitions() end, 'Type [D]efinition')
            nmap('<leader>ds', function() snacks.picker.lsp_symbols() end, '[D]ocument [S]ymbols')
            nmap('<leader>ws', function() snacks.picker.lsp_workspace_symbols() end, '[W]orkspace [S]ymbols')
            nmap('<leader>wS', function() snacks.picker.lsp_declarations() end, '[W]orkspace [S]ymbols, this workspace')
          end

          -- This is now the default in neovim v0.10+
          -- nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
          nmap('<C-S-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
          vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, { buffer = event.buf, desc = 'Signature Documentation' })
          vim.keymap.set('i', '<C-S-k>', vim.lsp.buf.hover, { buffer = event.buf, desc = 'Hover Documentation' })

          -- Lesser used LSP functionality
          nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
          nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
          nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
          nmap('<leader>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, '[W]orkspace [L]ist Folders')

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
        -- pylsp = {
        --   settings = {
        --     pylsp = {
        --       plugins = {
        --         pycodestyle = {
        --           -- ignore = {'W391'},
        --           maxLineLength = 200,
        --         },
        --       },
        --     },
        --   },
        -- },
        pylyzer = {
        },
        csharp_ls = {},
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
