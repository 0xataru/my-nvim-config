return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        gopls = {
          settings = {
            gopls = {
              hints = {
                assignVariableTypes = false,
                compositeLiteralFields = false,
                compositeLiteralTypes = false,
                constantValues = false,
                functionTypeParameters = false,
                parameterNames = false,
                rangeVariableTypes = false,
              },
            },
          },
        },
        bashls = {
          filetypes = { "sh", "bash", "zsh" },
          settings = {
            bashIde = {
              globPattern = "**/*.{sh,bash,zsh}",
              -- Disable the warning for unused variables
              validateOnSave = false,
              validateOnType = false,
            },
          },
          -- Disable bashls for .env files
          setup = function(server, opts)
            local lspconfig = require("lspconfig")
            local original_setup = lspconfig.bashls.setup

            lspconfig.bashls.setup = function(server_opts)
              -- Check if the current buffer is a .env file
              local bufname = vim.api.nvim_buf_get_name(0)
              if bufname:match("%.env") or bufname:match("/%.env") then
                -- Did not run bashls for .env files
                return
              end
              -- Use the original setup for other files
              return original_setup(server_opts)
            end
          end,
        },
      },
    },
  },
}
