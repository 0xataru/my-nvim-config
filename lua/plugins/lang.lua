return {
  -- Rust language support
  {
    "LazyVim/LazyVim",
    opts = {
      -- Import the rust extra
      { import = "lazyvim.plugins.extras.lang.rust" },
    },
  },

  -- Go language support
  {
    "LazyVim/LazyVim",
    opts = {
      -- Import the go extra
      { import = "lazyvim.plugins.extras.lang.go" },
    },
  },

  -- Mason configuration for Rust and Go tools
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- Rust tools
        "rust-analyzer",
        "codelldb",

        -- Go tools
        "gopls",
        "goimports",
        "gofumpt",
        "golines",
        "gomodifytags",
        "impl",
        "delve",

        -- General tools
        "stylua",
        "shellcheck",
        "shfmt",
        "flake8",
      },
    },
  },

  -- Additional Rust configuration
  {
    "mrcjkb/rustaceanvim",
    version = "^4", -- Recommended
    ft = { "rust" },
    config = function()
      vim.g.rustaceanvim = {
        -- Plugin configuration
        tools = {
          -- Enable hover actions
          hover_actions = {
            auto_focus = true,
          },
          -- Enable inlay hints
          inlay_hints = {
            auto = true,
            show_parameter_hints = true,
            parameter_hints_prefix = "<- ",
            other_hints_prefix = "=> ",
          },
        },
        -- LSP configuration
        server = {
          on_attach = function(client, bufnr)
            -- Rust-specific keymaps
            local opts = { buffer = bufnr, remap = false }
            vim.keymap.set("n", "<leader>ra", function()
              vim.cmd.RustLsp("codeAction")
            end, vim.tbl_extend("force", opts, { desc = "Code Action" }))
            vim.keymap.set("n", "<leader>rr", function()
              vim.cmd.RustLsp("runnables")
            end, vim.tbl_extend("force", opts, { desc = "Runnables" }))
            vim.keymap.set("n", "<leader>rd", function()
              vim.cmd.RustLsp("debuggables")
            end, vim.tbl_extend("force", opts, { desc = "Debuggables" }))
            vim.keymap.set("n", "<leader>rt", function()
              vim.cmd.RustLsp("testables")
            end, vim.tbl_extend("force", opts, { desc = "Testables" }))
            vim.keymap.set("n", "<leader>rh", function()
              vim.cmd.RustLsp("hover", "actions")
            end, vim.tbl_extend("force", opts, { desc = "Hover actions" }))
            vim.keymap.set("n", "<leader>re", function()
              vim.cmd.RustLsp("explainError")
            end, vim.tbl_extend("force", opts, { desc = "Explain Error" }))
            vim.keymap.set("n", "<leader>rc", function()
              vim.cmd.RustLsp("openCargo")
            end, vim.tbl_extend("force", opts, { desc = "Open Cargo.toml" }))
            vim.keymap.set("n", "<leader>rp", function()
              vim.cmd.RustLsp("parentModule")
            end, vim.tbl_extend("force", opts, { desc = "Parent Module" }))
            vim.keymap.set("n", "<leader>rj", function()
              vim.cmd.RustLsp("joinLines")
            end, vim.tbl_extend("force", opts, { desc = "Join Lines" }))
            vim.keymap.set("n", "<leader>rk", function()
              vim.cmd.RustLsp("hover", "range")
            end, vim.tbl_extend("force", opts, { desc = "Hover Range" }))
            vim.keymap.set("v", "<leader>rk", function()
              vim.cmd.RustLsp("hover", "range")
            end, vim.tbl_extend("force", opts, { desc = "Hover Range" }))
          end,
          default_settings = {
            ["rust-analyzer"] = {
              procMacro = {
                enable = true,
                -- ignored = {
                --   ["async-trait"] = { "async_trait" },
                --   ["napi-derive"] = { "napi" },
                --   ["async-recursion"] = { "async_recursion" },
                -- },
              },
              cargo = {
                allFeatures = true,
                loadOutDirsFromCheck = true,
                runBuildScripts = true,
              },
              -- Add clippy lints for Rust
              checkOnSave = {
                allFeatures = true,
                command = "clippy",
                extraArgs = { "--no-deps" },
              },
              -- procMacro = {
              --   enable = true,
              --   ignored = {
              --     ["async-trait"] = { "async_trait" },
              --     ["napi-derive"] = { "napi" },
              --     ["async-recursion"] = { "async_recursion" },
              --   },
              -- },
            },
          },
        },
      }
    end,
  },

  -- Additional Go configuration (disabled to avoid conflicts with nvim-dap)
  -- {
  --   "ray-x/go.nvim",
  --   dependencies = { "ray-x/guihua.lua", "neovim/nvim-lspconfig", "nvim-treesitter/nvim-treesitter" },
  --   config = function()
  --     require("go").setup({
  --       -- Go debugging options (disabled to avoid conflicts with nvim-dap)
  --       dap_debug = false,
  --       dap_debug_gui = false,
  --       dap_debug_keymap = false,
  --       dap_debug_vt = false,
  --
  --       -- Go tools options
  --       goimports = "gopls",
  --       gofmt = "golines", -- Use golines for line length control
  --       max_line_len = 120,
  --       tag_transform = false,
  --       -- Use gofumpt for better formatting, then golines for line length
  --       gofumpt = true,
  --       test_dir = "",
  --       comment_placeholder = "   ",
  --       lsp_cfg = true,
  --       lsp_gofumpt = true, -- Use gofumpt for LSP formatting
  --       lsp_on_attach = function(client, bufnr)
  --         -- Go-specific keymaps
  --         local opts = { buffer = bufnr, remap = false }
  --         vim.keymap.set("n", "<leader>gt", "<cmd>GoTest<CR>", vim.tbl_extend("force", opts, { desc = "Run tests" }))
  --         vim.keymap.set("n", "<leader>gT", "<cmd>GoTestFile<CR>", vim.tbl_extend("force", opts, { desc = "Run test file" }))
  --         vim.keymap.set("n", "<leader>ga", "<cmd>GoAddTest<CR>", vim.tbl_extend("force", opts, { desc = "Add test" }))
  --         vim.keymap.set("n", "<leader>gA", "<cmd>GoAddAllTest<CR>", vim.tbl_extend("force", opts, { desc = "Add all tests" }))
  --         vim.keymap.set("n", "<leader>gc", "<cmd>GoCoverage<CR>", vim.tbl_extend("force", opts, { desc = "Coverage" }))
  --         vim.keymap.set("n", "<leader>gC", "<cmd>GoCoverageToggle<CR>", vim.tbl_extend("force", opts, { desc = "Toggle coverage" }))
  --         vim.keymap.set("n", "<leader>gm", "<cmd>GoMod<CR>", vim.tbl_extend("force", opts, { desc = "Go mod" }))
  --         vim.keymap.set("n", "<leader>gi", "<cmd>GoImport<CR>", vim.tbl_extend("force", opts, { desc = "Go import" }))
  --         vim.keymap.set("n", "<leader>gf", "<cmd>GoFmt<CR>", vim.tbl_extend("force", opts, { desc = "Go format" }))
  --         vim.keymap.set("n", "<leader>gF", "<cmd>GoFmt gofumpt<CR>", vim.tbl_extend("force", opts, { desc = "Go format with gofumpt" }))
  --         vim.keymap.set("n", "<leader>gr", "<cmd>GoRun<CR>", vim.tbl_extend("force", opts, { desc = "Go run" }))
  --         vim.keymap.set("n", "<leader>gb", "<cmd>GoBuild<CR>", vim.tbl_extend("force", opts, { desc = "Go build" }))
  --         vim.keymap.set("n", "<leader>gs", "<cmd>GoFillStruct<CR>", vim.tbl_extend("force", opts, { desc = "Fill struct" }))
  --         vim.keymap.set("n", "<leader>gj", "<cmd>GoAddTag<CR>", vim.tbl_extend("force", opts, { desc = "Add tags" }))
  --         vim.keymap.set("n", "<leader>gJ", "<cmd>GoRmTag<CR>", vim.tbl_extend("force", opts, { desc = "Remove tags" }))
  --         vim.keymap.set("n", "<leader>ge", "<cmd>GoIfErr<CR>", vim.tbl_extend("force", opts, { desc = "Add if err" }))
  --         vim.keymap.set("n", "<leader>gd", "<cmd>GoDoc<CR>", vim.tbl_extend("force", opts, { desc = "Go doc" }))
  --       end,
  --       lsp_keymaps = true,
  --       lsp_codelens = true,
  --       diagnostic = {
  --         hdlr = false,
  --         underline = true,
  --         virtual_text = { spacing = 0, prefix = "■" },
  --         signs = true,
  --         update_in_insert = false,
  --       },
  --       lsp_document_formatting = true,
  --       lsp_inlay_hints = {
  --         enable = true,
  --         -- Only show inlay hints for the current line
  --         only_current_line = false,
  --         -- Event which triggers a refresh of the inlay hints.
  --         only_current_line_autocmd = "CursorHold",
  --         -- whether to show variable name before type hints with the inlay hints or not
  --         show_variable_name = true,
  --         -- prefix for parameter hints
  --         parameter_hints_prefix = "󰊕 ",
  --         show_parameter_hints = true,
  --         -- prefix for all the other hints (type, chaining)
  --         other_hints_prefix = "=> ",
  --         -- whether to align to the length of the longest line in the file
  --         max_len_align = false,
  --         -- padding from the left if max_len_align is true
  --         max_len_align_padding = 1,
  --         -- whether to align to the extreme right or not
  --         right_align = false,
  --         -- padding from the right if right_align is true
  --         right_align_padding = 6,
  --         -- The color of the hints
  --         highlight = "Comment",
  --       },
  --       gopls_cmd = nil,
  --       gopls_remote_auto = true,
  --       gocoverage_sign = "█",
  --       sign_priority = 5,
  --       dap_debug_gui = true,
  --       textobjects = true,
  --       test_runner = "go",
  --       verbose_tests = true,
  --       run_in_floaterm = false,
  --       luasnip = true,
  --     })
  --   end,
  --   event = { "CmdlineEnter" },
  --   ft = { "go", "gomod" },
  --   build = ':lua require("go.install").update_all_sync()',
  -- },
}
