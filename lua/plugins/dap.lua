return {
  -- DAP (Debug Adapter Protocol)
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-neotest/nvim-nio",
      "jay-babu/mason-nvim-dap.nvim",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      -- Setup mason-nvim-dap
      require("mason-nvim-dap").setup({
        ensure_installed = { "codelldb", "delve" },
        handlers = {},
      })

      -- Setup DAP UI
      dapui.setup({
        icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
        mappings = {
          -- Use a table to apply multiple mappings
          expand = { "<CR>", "<2-LeftMouse>" },
          open = "o",
          remove = "d",
          edit = "e",
          repl = "r",
          toggle = "t",
        },
        element_mappings = {},
        expand_lines = true,
        force_buffers = true,
        controls = {
          enabled = true,
          element = "repl",
          icons = {
            pause = "",
            play = "",
            step_into = "",
            step_over = "",
            step_out = "",
            step_back = "",
            run_last = "",
            terminate = "",
          },
        },
        render = {
          max_type_length = nil,
          max_value_lines = 100,
          indent = 1,
        },
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.25 },
              { id = "breakpoints", size = 0.25 },
              { id = "stacks", size = 0.25 },
              { id = "watches", size = 0.25 },
            },
            size = 40,
            position = "left",
          },
          {
            elements = {
              { id = "repl", size = 0.5 },
              { id = "console", size = 0.5 },
            },
            size = 10,
            position = "bottom",
          },
        },
        floating = {
          max_height = nil,
          max_width = nil,
          border = "single",
          mappings = {
            close = { "q", "<Esc>" },
          },
        },
      })

      -- Setup virtual text
      require("nvim-dap-virtual-text").setup({
        enabled = true,
        enabled_commands = true,
        highlight_changed_variables = true,
        highlight_new_as_changed = false,
        show_stop_reason = true,
        commented = false,
        only_first_definition = true,
        all_references = false,
        display_callback = function(variable, _, _, _, options)
          if options.virt_text_pos == "inline" then
            return " = " .. variable.value
          else
            return variable.name .. " = " .. variable.value
          end
        end,
      })

      -- Custom Go adapter
      dap.adapters.go = function(callback, config)
        local port = 38697
        ---@diagnostic disable-next-line: undefined-field
        local stdout = vim.loop.new_pipe(false)
        ---@diagnostic disable-next-line: undefined-field
        local stderr = vim.loop.new_pipe(false)
        local handle

        -- Use cwd from config if available, otherwise use current directory
        local cwd = config.cwd or vim.fn.getcwd()

        -- Ensure cwd is a string, not a function
        if type(cwd) == "function" then
          cwd = cwd()
        end

        -- Expand workspaceFolder if present
        if cwd:match("${workspaceFolder}") then
          cwd = cwd:gsub("${workspaceFolder}", vim.fn.getcwd())
        end

        ---@diagnostic disable-next-line: undefined-field
        handle, pid_or_err = vim.loop.spawn("dlv", {
          stdio = { nil, stdout, stderr },
          args = { "dap", "-l", "127.0.0.1:" .. port },
          cwd = cwd,
          detached = true,
        }, function(exit_code)
          if stdout then
            stdout:close()
          end
          if stderr then
            stderr:close()
          end
          if handle then
            handle:close()
          end
        end)

        if not handle then
          vim.notify("Failed to launch delve: " .. tostring(pid_or_err), vim.log.levels.ERROR)
          return
        end

        -- Wait a bit for delve to start
        vim.defer_fn(function()
          callback({ type = "server", host = "127.0.0.1", port = port })
        end, 100)
      end

      -- Add more verbose logging for Go debugging
      dap.set_log_level("DEBUG")

      -- Custom Go configurations
      dap.configurations.go = {
        {
          name = "Debug Go",
          type = "go",
          request = "launch",
          mode = "debug",
          program = "${workspaceFolder}",
          args = {},
          cwd = "${workspaceFolder}",
          console = "integratedTerminal",
          stopOnEntry = false,
          showLog = true,
          trace = "verbose",
        },
      }

      -- Rust debugging setup using codelldb
      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
          command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
          args = { "--port", "${port}" },
        },
      }

      dap.configurations.rust = {
        {
          name = "Launch file",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
          args = {},
        },
        {
          name = "Launch file (release)",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/release/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
          args = {},
        },
      }

      -- Auto open/close DAP UI
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      -- Command to validate launch.json
      vim.api.nvim_create_user_command("DapValidateLaunchJson", function()
        local launch_json_path = vim.fn.getcwd() .. "/.vscode/launch.json"
        if vim.fn.filereadable(launch_json_path) == 1 then
          local ok, content = pcall(vim.fn.readfile, launch_json_path)
          if ok then
            local json_content = table.concat(content, "\n")
            local decode_ok, result = pcall(vim.fn.json_decode, json_content)
            if decode_ok then
              vim.notify("launch.json is valid ✓", vim.log.levels.INFO)
            else
              vim.notify("launch.json has syntax errors: " .. result, vim.log.levels.ERROR)
            end
          else
            vim.notify("Failed to read launch.json", vim.log.levels.ERROR)
          end
        else
          vim.notify("launch.json not found in .vscode/", vim.log.levels.WARN)
        end
      end, { desc = "Validate launch.json syntax" })

      -- Command to show DAP logs
      vim.api.nvim_create_user_command("DapShowLog", function()
        local log_path = vim.fn.stdpath("cache") .. "/dap.log"
        if vim.fn.filereadable(log_path) == 1 then
          vim.cmd("split " .. log_path)
        else
          vim.notify("DAP log file not found at: " .. log_path, vim.log.levels.WARN)
        end
      end, { desc = "Show DAP log file" })

      -- Command to test delve
      vim.api.nvim_create_user_command("DapTestDelve", function()
        local result = vim.fn.system("dlv version")
        if vim.v.shell_error == 0 then
          vim.notify("Delve is working:\n" .. result, vim.log.levels.INFO)
        else
          vim.notify("Delve failed:\n" .. result, vim.log.levels.ERROR)
        end
      end, { desc = "Test delve installation" })

      -- Command to test environment variables
      vim.api.nvim_create_user_command("DapTestEnv", function()
        local crm_go_dir = vim.fn.getcwd() .. "/crm_go"
        local env_file = crm_go_dir .. "/.env"

        if vim.fn.filereadable(env_file) == 1 then
          local content = vim.fn.readfile(env_file)
          local env_content = table.concat(content, "\n")
          vim.notify("Environment file found:\n" .. env_content, vim.log.levels.INFO)
        else
          vim.notify("Environment file not found at: " .. env_file, vim.log.levels.ERROR)
        end

        -- Test if we can read the environment file
        local stage_env = vim.fn.getcwd() .. "/.vscode/stage.env"
        if vim.fn.filereadable(stage_env) == 1 then
          local content = vim.fn.readfile(stage_env)
          local env_content = table.concat(content, "\n")
          vim.notify("Stage env file found:\n" .. env_content, vim.log.levels.INFO)
        else
          vim.notify("Stage env file not found at: " .. stage_env, vim.log.levels.ERROR)
        end
      end, { desc = "Test environment variables" })

      -- Command to test Rust debugger
      vim.api.nvim_create_user_command("DapTestRust", function()
        local codelldb_path = vim.fn.stdpath("data") .. "/mason/bin/codelldb"
        if vim.fn.filereadable(codelldb_path) == 1 then
          local result = vim.fn.system(codelldb_path .. " --version")
          if vim.v.shell_error == 0 then
            vim.notify("codelldb is working:\n" .. result, vim.log.levels.INFO)
          else
            vim.notify("codelldb failed:\n" .. result, vim.log.levels.ERROR)
          end
        else
          vim.notify("codelldb not found at: " .. codelldb_path, vim.log.levels.ERROR)
        end
      end, { desc = "Test Rust debugger" })

      -- Command to show all DAP configurations
      vim.api.nvim_create_user_command("DapShowConfigs", function()
        local configs = dap.configurations.go or {}
        vim.notify("Go DAP configurations: " .. vim.inspect(configs), vim.log.levels.INFO)
      end, { desc = "Show all Go DAP configurations" })

      -- Command to create proper launch.json for Go project
      vim.api.nvim_create_user_command("DapCreateLaunchJson", function()
        local vscode_dir = vim.fn.getcwd() .. "/.vscode"
        local launch_json_path = vscode_dir .. "/launch.json"

        -- Create .vscode directory if it doesn't exist
        if vim.fn.isdirectory(vscode_dir) == 0 then
          vim.fn.mkdir(vscode_dir, "p")
        end

        local launch_config = {
          version = "0.2.0",
          configurations = {
            {
              name = "Debug Go",
              type = "go",
              request = "launch",
              mode = "debug",
              program = "${workspaceFolder}",
              args = {},
              cwd = "${workspaceFolder}",
              console = "integratedTerminal",
              stopOnEntry = false,
              showLog = true,
              trace = "verbose",
            },
          },
        }

        local json_content = vim.fn.json_encode(launch_config)
        local ok, err = pcall(vim.fn.writefile, vim.fn.split(json_content, "\n"), launch_json_path)

        if ok then
          vim.notify("Created launch.json at: " .. launch_json_path, vim.log.levels.INFO)
        else
          vim.notify("Failed to create launch.json: " .. tostring(err), vim.log.levels.ERROR)
        end
      end, { desc = "Create proper launch.json for Go project" })

      -- Command to setup environment files for Go debugging
      vim.api.nvim_create_user_command("DapSetupEnv", function()
        local crm_go_dir = vim.fn.getcwd() .. "/crm_go"
        local vscode_dir = vim.fn.getcwd() .. "/.vscode"

        -- Check if crm_go directory exists
        if vim.fn.isdirectory(crm_go_dir) == 0 then
          vim.notify("crm_go directory not found", vim.log.levels.ERROR)
          return
        end

        -- Create symbolic links for .env files
        local stage_env = vscode_dir .. "/stage.env"
        local go_env = vscode_dir .. "/go.env"
        local stage_link = crm_go_dir .. "/.env"
        local go_link = crm_go_dir .. "/.env.go"

        -- Create symbolic link for stage.env
        if vim.fn.filereadable(stage_env) == 1 then
          local cmd = string.format("ln -sf %s %s", stage_env, stage_link)
          local result = vim.fn.system(cmd)
          if vim.v.shell_error == 0 then
            vim.notify("Created .env link for stage environment", vim.log.levels.INFO)
          else
            vim.notify("Failed to create .env link: " .. result, vim.log.levels.ERROR)
          end
        else
          vim.notify("stage.env not found at: " .. stage_env, vim.log.levels.WARN)
        end

        -- Create symbolic link for go.env
        if vim.fn.filereadable(go_env) == 1 then
          local cmd = string.format("ln -sf %s %s", go_env, go_link)
          local result = vim.fn.system(cmd)
          if vim.v.shell_error == 0 then
            vim.notify("Created .env.go link for go environment", vim.log.levels.INFO)
          else
            vim.notify("Failed to create .env.go link: " .. result, vim.log.levels.ERROR)
          end
        else
          vim.notify("go.env not found at: " .. go_env, vim.log.levels.WARN)
        end
      end, { desc = "Setup environment files for Go debugging" })

      -- Keymaps
      vim.keymap.set("n", "<leader>dt", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
      vim.keymap.set("n", "<leader>dT", function()
        dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end, { desc = "Set conditional breakpoint" })
      vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Continue" })
      vim.keymap.set("n", "<leader>ds", dap.step_over, { desc = "Step over" })
      vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Step into" })
      vim.keymap.set("n", "<leader>do", dap.step_out, { desc = "Step out" })
      vim.keymap.set("n", "<leader>dr", dap.repl.open, { desc = "Open REPL" })
      vim.keymap.set("n", "<leader>dl", dap.run_last, { desc = "Run last" })
      vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "Toggle DAP UI" })
      vim.keymap.set("n", "<leader>dq", function()
        dap.terminate()
        dapui.close()
      end, { desc = "Terminate debug session" })

      -- Hover variables
      vim.keymap.set({ "n", "v" }, "<leader>dh", function()
        require("dap.ui.widgets").hover()
      end, { desc = "Hover variables" })

      -- Preview variables
      vim.keymap.set({ "n", "v" }, "<leader>dp", function()
        require("dap.ui.widgets").preview()
      end, { desc = "Preview variables" })

      -- Frames and scopes
      vim.keymap.set("n", "<leader>df", function()
        local widgets = require("dap.ui.widgets")
        widgets.centered_float(widgets.frames)
      end, { desc = "Show frames" })

      vim.keymap.set("n", "<leader>dS", function()
        local widgets = require("dap.ui.widgets")
        widgets.centered_float(widgets.scopes)
      end, { desc = "Show scopes" })
    end,
  },
}

