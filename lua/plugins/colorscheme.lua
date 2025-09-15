return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    init = function()
      vim.cmd.colorscheme 'catppuccin-latte'

      vim.cmd([[
        highlight LspReferenceText  guibg=#afdcfa
        highlight LspReferenceRead  guibg=#92f7aa
        highlight LspReferenceWrite guibg=#88e39e

        " Revert catppuccin's Comment highlight change, to make comments lighter
        " and easier to distinguish from code
        " highlight Comment guifg=#7c7f93 " catppuccin's new colour
        " highlight Comment guifg=#9ca0b0 " catppuccin's old colour
        highlight Comment guifg=#8790a1
        highlight @variable.parameter guifg=#569bf5
        highlight @variable guifg=#1f1f1f
        highlight @property guifg=#473d87
        highlight @lsp.type.enumMember guifg=#d12e2e
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
