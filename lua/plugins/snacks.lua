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
      picker = { enabled = true },
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
  }
}
