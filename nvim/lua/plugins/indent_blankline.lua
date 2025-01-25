local highlight = {
  "CursorColumn",
  "Whitespace",
}

return {
  {
    -- "lukas-reineke/indent-blankline.nvim",
    -- event = "LazyFile",
    -- opts = function()
    --   -- Add the highlight setup hook at the start of the opts function
    --   local hooks = require("ibl.hooks")
    --   hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
    --     -- Adjust the bg value to make it lighter or darker as needed
    --     vim.api.nvim_set_hl(0, "CursorColumn", { bg = "#757474" })
    --     vim.api.nvim_set_hl(0, "Whitespace", { fg = "#fafafa" })
    --   end)
    --
    --   -- Your existing Snacks configuration
    --   Snacks.toggle({
    --     name = "Indention Guides",
    --     get = function()
    --       return require("ibl.config").get_config(0).enabled
    --     end,
    --     set = function(state)
    --       require("ibl").setup_buffer(0, { enabled = state })
    --     end,
    --   }):map("<leader>ug")
    --
    --   return {
    --     indent = { highlight = highlight, char = "" },
    --     whitespace = {
    --       highlight = highlight,
    --       remove_blankline_trail = true,
    --     },
    --     scope = { enabled = false },
    --     exclude = {
    --       filetypes = {
    --         "Trouble",
    --         "alpha",
    --         "dashboard",
    --         "help",
    --         "lazy",
    --         "mason",
    --         "neo-tree",
    --         "notify",
    --         "snacks_dashboard",
    --         "snacks_notif",
    --         "snacks_terminal",
    --         "snacks_win",
    --         "toggleterm",
    --         "trouble",
    --       },
    --     },
    --   }
    -- end,
    -- main = "ibl",
  },
}
