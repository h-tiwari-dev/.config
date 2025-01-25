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
        buf_ignore = { "nofile" },
        debounce = 50,
        filetypes = { "markdown", "quarto", "rmd" },
        highlight_groups = "dynamic",
        hybrid_modes = { "n" },
        injections = {},
        initial_state = true,
        max_file_length = 1000,
        modes = { "n", "no", "c" },
        render_distance = 100,
        split_conf = {},

        -- Customize rendering options as needed
        block_quotes = {},
        checkboxes = {},
        code_blocks = {},
        footnotes = {},
        headings = {},
        horizontal_rules = {},
        html = {},
        inline_codes = {},
        latex = {},
        links = {},
        list_items = {},
        tables = {},
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
