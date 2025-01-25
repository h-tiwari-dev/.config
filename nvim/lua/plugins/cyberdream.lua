return {
  {
    "scottmckendry/cyberdream.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("cyberdream").setup({
        transparent = true,
        italic_comments = true,
        highlight_groups = {
          Comment = { italic = true, fg = "#63698c" },
          LineNr = { fg = "#3b4261" },
          CursorLine = { bg = "#1a1b26" },
          Visual = { bg = "#283457" },
          Search = { bg = "#3d59a1", fg = "#c0caf5" },
          IncSearch = { bg = "#9ece6a", fg = "#1a1b26" },
          ColorColumn = { bg = "#1f2335" },
          SignColumn = { bg = "NONE" },
          DiffAdd = { fg = "#9ece6a" },
          DiffChange = { fg = "#e0af68" },
          DiffDelete = { fg = "#f7768e" },
        },
        theme = {
          variant = "default",
          colors = {
            bg = "#1a1b26",
            fg = "#c0caf5",
            red = "#f7768e",
            green = "#9ece6a",
            yellow = "#e0af68",
            blue = "#7aa2f7",
            magenta = "#bb9af7",
            cyan = "#7dcfff",
          },
        },
      })
      vim.cmd("colorscheme cyberdream")
    end,
  },
}
