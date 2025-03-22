return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
      bigfile = { enabled = true },
      dashboard = { enabled = true },
      indent = { enabled = true },
      input = { enabled = true },
      quickfile = { enabled = true },
      scroll = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
      animate = {
        duration = 20, -- ms per step
        easing = "linear",
        fps = 60, -- frames per second. Global setting for all animations
      },
      dim = {
        zen = {
          toggles = {
            dim = true,
            git_signs = false,
            mini_diff_signs = false,
          },
          show = {
            statusline = false,
            tabline = false,
          },
          win = { style = "zen" },
          on_open = function(win) end,
          on_close = function(win) end,
          zoom = {
            toggles = {},
            show = {
              statusline = true,
              tabline = true,
            },
            win = {
              backdrop = false,
              width = 0,
            },
          },
        },
        scope = {
          min_size = 5,
          max_size = 20,
          siblings = true,
        },
        animate = {
          enabled = vim.fn.has("nvim-0.10") == 1,
          easing = "outQuad",
          duration = {
            step = 20, -- ms per step
            total = 300, -- maximum duration
          },
        },
        filter = function(buf)
          return vim.g.snacks_dim ~= false and vim.b[buf].snacks_dim ~= false and vim.bo[buf].buftype == ""
        end,
      },
      git = {
        blame_line = {
          width = 0.6,
          height = 0.6,
          border = "rounded",
          title = " Git Blame ",
          title_pos = "center",
          ft = "git",
        },
      },
      picker = {
        enabled = true,
        telescope = {
          layout_config = {
            width = 0.7,
            height = 0.8,
          },
        },
        sort = {
          -- Sort modes for different pickers
          buffers = "modified",
          oldfiles = "modified",
          files = "modified",
        },
      },
      image = {
        enabled = true,
        formats = {
          "png",
          "jpg",
          "jpeg",
          "gif",
          "bmp",
          "webp",
          "tiff",
          "heic",
          "avif",
          "mp4",
          "mov",
          "avi",
          "mkv",
          "webm",
          "pdf",
        },
        doc = {
          enabled = true,
          inline = true,
          float = true,
          max_width = 80,
          max_height = 40,
        },
        img_dirs = { "img", "images", "assets", "static", "public", "media", "attachments" },
        wo = {
          wrap = false,
          number = false,
          relativenumber = false,
          cursorcolumn = false,
          signcolumn = "no",
          foldcolumn = "0",
          list = false,
          spell = false,
          statuscolumn = "",
        },
      },
      scope = {
        enabled = true,
        min_size = 2,
        cursor = true,
        edge = true,
        siblings = false,
        filter = function(buf)
          return vim.bo[buf].buftype == ""
        end,
        debounce = 30,
        treesitter = {
          enabled = true,
          injections = true,
          blocks = {
            enabled = false,
            "function_declaration",
            "function_definition",
            "method_declaration",
            "method_definition",
            "class_declaration",
            "class_definition",
            "do_statement",
            "while_statement",
            "repeat_statement",
            "if_statement",
            "for_statement",
          },
          field_blocks = {
            "local_declaration",
          },
        },
        keys = {
          textobject = {
            ii = {
              min_size = 2,
              edge = false,
              cursor = false,
              treesitter = { blocks = { enabled = false } },
              desc = "inner scope",
            },
            ai = {
              cursor = false,
              min_size = 2,
              treesitter = { blocks = { enabled = false } },
              desc = "full scope",
            },
          },
          jump = {
            ["[i"] = {
              min_size = 1,
              bottom = false,
              cursor = false,
              edge = true,
              treesitter = { blocks = { enabled = false } },
              desc = "jump to top edge of scope",
            },
            ["]i"] = {
              min_size = 1,
              bottom = true,
              cursor = false,
              edge = true,
              treesitter = { blocks = { enabled = false } },
              desc = "jump to bottom edge of scope",
            },
          },
        },
      },
      notifier = {
        enabled = true,
        timeout = 3000, -- default timeout in ms
        width = { min = 40, max = 0.4 },
        height = { min = 1, max = 0.6 },
        margin = { top = 0, right = 1, bottom = 0 },
        padding = true,
        sort = { "level", "added" },
        level = vim.log.levels.TRACE,
        icons = {
          error = " ",
          warn = " ",
          info = " ",
          debug = " ",
          trace = " ",
        },
        keep = function(notif)
          return vim.fn.getcmdpos() > 0
        end,
        style = "compact",
        top_down = true,
        date_format = "%R",
        more_format = " ↓ %d lines ",
        refresh = 50,
        notification = {
          border = "rounded",
          zindex = 100,
          ft = "markdown",
          wo = {
            winblend = 5,
            wrap = false,
            conceallevel = 2,
            colorcolumn = "",
          },
          bo = { filetype = "snacks_notif" },
        },
        notification_history = {
          border = "rounded",
          zindex = 100,
          width = 0.6,
          height = 0.6,
          minimal = false,
          title = " Notification History ",
          title_pos = "center",
          ft = "markdown",
          bo = { filetype = "snacks_notif_history", modifiable = false },
          wo = { winhighlight = "Normal:SnacksNotifierHistory" },
          keys = { q = "close" },
        },
      },
    },
  },
}
