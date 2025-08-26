return {
  "akinsho/bufferline.nvim",
  event = "VeryLazy",
  opts = function()
    return {
      options = {
        mode = "buffers",
        separator_style = "thick",
        always_show_bufferline = true,
        show_buffer_close_icons = true,
        show_close_icon = false,
        color_icons = true,
        diagnostics = "nvim_lsp",
        diagnostics_indicator = function(_, _, diag)
          local icons = require("lazyvim.config").icons.diagnostics
          local ret = (diag.error and icons.Error .. diag.error .. " " or "")
            .. (diag.warning and icons.Warn .. diag.warning or "")
          return vim.trim(ret)
        end,
        offsets = {
          {
            filetype = "neo-tree",
            text = "📁 Explorer",
            highlight = "Directory",
            text_align = "left",
            separator = true,
          },
        },
        groups = {
          options = {
            toggle_hidden_on_enter = true,
          },
          items = {
            {
              name = "🧪 Tests",
              highlight = { gui = "bold", guisp = "blue" },
              auto_close = false,
              matcher = function(buf)
                return buf.name:match("%_test") or buf.name:match("%_spec")
              end,
            },
            {
              name = "📚 Docs",
              highlight = { gui = "bold", guisp = "green" },
              auto_close = true,
              matcher = function(buf)
                return buf.name:match("%.md") or buf.name:match("%.txt")
              end,
            },
            {
              name = "⚙️ Config",
              highlight = { gui = "bold", guisp = "yellow" },
              auto_close = false,
              matcher = function(buf)
                return buf.name:match("%.json") or buf.name:match("%.toml") or buf.name:match("%.yaml")
              end,
            },
          },
        },
        hover = {
          enabled = true,
          delay = 200,
          reveal = { "close" },
        },
        highlights = {
          buffer_selected = {
            bold = true,
            italic = true,
          },
          buffer_visible = {
            italic = true,
          },
        },
      },
    }
  end,
}
