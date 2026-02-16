return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    init = function()
      vim.cmd.colorscheme 'catppuccin-latte'

      vim.cmd([[
        highlight Comment guifg=#8790a1
        highlight Folded guibg=#eeeef5 guifg=#aaaaaa
        highlight LspReferenceRead  guibg=#92f7aa
        highlight LspReferenceTarget guibg=#bfbcfa
        highlight LspReferenceText  guibg=#afdcfa
        highlight LspReferenceWrite guibg=#88e39e

        highlight @variable.parameter guifg=#569bf5
        highlight @variable guifg=#1f1f1f
        highlight @property guifg=#473d87
        highlight @lsp.type.enumMember guifg=#d12e2e

        highlight eolSpace ctermbg=238 guibg=#e6e6e6 guifg=#bbbbbb
        match eolSpace /\s\+$/
      ]])
    end,
    opts = {
      integrations = {
        -- harpoon = true,
        mason = true,
        nvim_surround = true,
      },
    },
  },
}
