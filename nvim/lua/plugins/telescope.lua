return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      {
        "nvim-telescope/telescope-live-grep-args.nvim",
        version = "^1.0.0",
      },
      { "nvim-lua/plenary.nvim" }, -- Required dependency
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" }, -- Optional fuzzy finder optimization
      { "nvim-telescope/telescope-file-browser.nvim" }, -- File browser extension
    },
    config = function()
      local telescope = require("telescope")
      -- require("telescope").load_extension("dap")

      -- Telescope setup
      telescope.setup({
        defaults = {
          prompt_prefix = " ",
          selection_caret = " ",
          path_display = { "smart" },
          mappings = {
            i = {
              ["<C-j>"] = require("telescope.actions").move_selection_next,
              ["<C-k>"] = require("telescope.actions").move_selection_previous,
              ["<C-c>"] = require("telescope.actions").close,
            },
            n = {
              ["<C-c>"] = require("telescope.actions").close,
            },
          },
        },
        pickers = {
          find_files = {
            hidden = true, -- Show hidden files
          },
        },
        extensions = {
          live_grep_args = {
            auto_quoting = true, -- Enable/disable auto-quoting
          },
          fzf = {
            fuzzy = true, -- Enable fuzzy matching
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case", -- Or "ignore_case" or "respect_case"
          },
        },
      })

      -- Load extensions
      telescope.load_extension("live_grep_args")
      telescope.load_extension("fzf")
      telescope.load_extension("file_browser")

      -- Optional key mappings
      local builtin = require("telescope.builtin")
      local map = vim.api.nvim_set_keymap
      local opts = { noremap = true, silent = true }

      map("n", "<leader>ff", "<cmd>lua require('telescope.builtin').find_files()<CR>", opts)
      map("n", "<leader>fg", "<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>", opts)
      map("n", "<leader>fb", "<cmd>lua require('telescope.builtin').buffers()<CR>", opts)
      map("n", "<leader>fh", "<cmd>lua require('telescope.builtin').help_tags()<CR>", opts)
      map("n", "<leader>fE", "<cmd>lua require('telescope').extensions.file_browser.file_browser()<CR>", opts)
    end,
  },
}
