-- File: plugins/markview.lua
return {
  {
    "OXY2DEV/markview.nvim",
    lazy = false, -- Recommended to not lazy-load
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      -- Setup markview plugin
      require("markview").setup({
        highlight_groups = "dynamic",
        preview = {
          ignore_buftypes = { "nofile" },
          debounce = 50,
          filetypes = { "markdown", "quarto", "rmd" },
          hybrid_modes = { "n" },
          enable = true,
          max_buf_lines = 1000,
          modes = { "n", "no", "c" },
          draw_range = 100,
          splitview_winopts = {},
        },

        -- Customize rendering options as needed
        markdown = {
          headings = {},
          horizontal_rules = {},
          list_items = {},
          tables = {},
        },

        -- Other rendering options
        block_quotes = {},
        checkboxes = {},
        code_blocks = {},
        footnotes = {},
        html = {},
        inline_codes = {},
        latex = {},
        links = {},
      })

      -- Key mappings for markview commands
      vim.api.nvim_set_keymap("n", "<Leader>mp", ":Markview toggle<CR>", { noremap = true, silent = true }) -- Toggle preview
      vim.api.nvim_set_keymap("n", "<Leader>mh", ":Markview hybridToggle<CR>", { noremap = true, silent = true }) -- Toggle hybrid mode
      vim.api.nvim_set_keymap("n", "<Leader>ms", ":Markview splitToggle<CR>", { noremap = true, silent = true }) -- Toggle split view
      vim.api.nvim_set_keymap("n", "<Leader>me", ":Markview enableAll<CR>", { noremap = true, silent = true }) -- Enable all features
      vim.api.nvim_set_keymap("n", "<Leader>md", ":Markview disableAll<CR>", { noremap = true, silent = true }) -- Disable all features
    end,
  },
}
