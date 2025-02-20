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
        highlight Comment guifg=#9ca0b0   " catppuccin's old colour
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
