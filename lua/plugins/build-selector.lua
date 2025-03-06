return {
  {
    'segcore/build-selector.nvim',
    dir = '~/p/build-selector.nvim/',
    config = function()
      local bs = require('build-selector')
      bs.setup({ simplify = false})
      vim.keymap.set('n', '<leader>b', bs.choose_default, { desc = 'Open build selector' })
      vim.keymap.set('n', '<leader>B', function()
        local choices = bs.choices()
        choices = vim.tbl_filter(function(entry)
          return string.match(entry, "docker")
        end, choices)
        bs.choose(choices)
      end, { desc = 'Open build selector for docker builds' })
    end,
  },
}
