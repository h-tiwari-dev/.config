return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "williamboman/mason.nvim",
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "mfussenegger/nvim-dap-python",
      "theHamsta/nvim-dap-virtual-text",
      "mxsdev/nvim-dap-vscode-js",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      require("nvim-dap-virtual-text").setup({})

      -- Function to find the most appropriate Python interpreter
      local function get_python_path()
        -- Use whereis to find Python paths
        local whereis_output = vim.fn.trim(vim.fn.system("whereis -b python python3"))

        -- Split the output and filter executable paths
        local paths = {}
        for path in whereis_output:gmatch("%S+") do
          -- Skip the "python:" prefix and filter for actual paths
          if path ~= "python:" and path ~= "python3:" and vim.fn.executable(path) == 1 then
            table.insert(paths, path)
          end
        end

        -- Check for virtual environment
        local venv_path = os.getenv("VIRTUAL_ENV")
        if venv_path and vim.fn.executable(venv_path .. "/bin/python") == 1 then
          table.insert(paths, 1, venv_path .. "/bin/python")
        end

        -- Check for pyenv
        local pyenv_path = vim.fn.trim(vim.fn.system("pyenv which python 2>/dev/null"))
        if vim.v.shell_error == 0 and vim.fn.executable(pyenv_path) == 1 then
          table.insert(paths, 1, pyenv_path)
        end

        -- Check for poetry virtual environment
        local poetry_venv = vim.fn.trim(vim.fn.system("poetry env info -p 2>/dev/null"))
        if vim.v.shell_error == 0 then
          local poetry_python = poetry_venv .. "/bin/python"
          if vim.fn.executable(poetry_python) == 1 then
            table.insert(paths, 1, poetry_python)
          end
        end

        -- Return the first valid path
        if #paths > 0 then
          return paths[1]
        end

        -- Last resort
        return vim.fn.exepath("python3") or vim.fn.exepath("python")
      end

      -- Utility function to compile and debug current C++ file
      local function compile_and_debug_cpp_file()
        local current_file = vim.fn.expand("%:p")
        local output_file = vim.fn.expand("%:p:r")

        local compile_cmd = string.format("g++ -std=c++11 -g %s -o %s", current_file, output_file)
        local compile_result = vim.fn.system(compile_cmd)

        if vim.v.shell_error ~= 0 then
          vim.notify("Compilation failed: " .. compile_result, vim.log.levels.ERROR)
          return
        end

        dap.run({
          type = "codelldb",
          request = "launch",
          name = "Debug current C++ file",
          program = output_file,
          cwd = vim.fn.getcwd(),
          stopOnEntry = false,
        })
      end

      -- Utility function to debug current Python file
      local function debug_python_file()
        local current_file = vim.fn.expand("%:p")
        local python_path = get_python_path()

        vim.notify("Using Python interpreter: " .. python_path, vim.log.levels.INFO)

        dap.run({
          type = "python",
          request = "launch",
          name = "Debug current Python file",
          program = current_file,
          pythonPath = python_path,
          console = "integratedTerminal",
        })
      end

      -- Utility function to debug RQ worker
      local function debug_rq_worker()
        local python_path = get_python_path()
        local workspace_folder = vim.fn.getcwd()

        -- Print debugging information
        vim.notify("Python Path: " .. python_path, vim.log.levels.INFO)
        vim.notify("Working Directory: " .. workspace_folder, vim.log.levels.INFO)

        dap.run({
          type = "python",
          request = "launch",
          name = "Debug RQ Worker",
          module = "rq.cli",
          args = { "worker", "high", "default", "low" },
          pythonPath = python_path,
          console = "integratedTerminal",
          cwd = workspace_folder,
          justMyCode = false,
          env = {
            PYTHONPATH = workspace_folder,
          },
          stopOnEntry = false,
          redirectOutput = true,
          showReturnValue = true,
        })

        -- Add error listener
        dap.listeners.after.event_error["rq-error"] = function(session, body)
          vim.notify(
            string.format("Debug error: %s\nTrace: %s", vim.inspect(body), vim.inspect(session.current_frame)),
            vim.log.levels.ERROR
          )
        end
      end

      -- Utility function to debug Flask application
      local function debug_flask_app()
        local python_path = get_python_path()
        local workspace_folder = vim.fn.getcwd()

        -- Attempt to find Flask app
        local flask_app =
          vim.fn.input("Flask app entry point (default: notes_app.py): ", workspace_folder .. "/notes_app.py", "file")

        -- Verify if the file exists
        if vim.fn.filereadable(flask_app) == 0 then
          vim.notify("Flask app file not found: " .. flask_app, vim.log.levels.ERROR)
          return
        end

        -- Print debugging information
        vim.notify("Python Path: " .. python_path, vim.log.levels.INFO)
        vim.notify("Flask App: " .. flask_app, vim.log.levels.INFO)
        vim.notify("Working Directory: " .. workspace_folder, vim.log.levels.INFO)

        dap.run({
          type = "python",
          request = "launch",
          name = "Debug Flask App",
          program = flask_app,
          pythonPath = python_path,
          console = "integratedTerminal",
          cwd = workspace_folder,
          justMyCode = false,
          env = {
            FLASK_APP = vim.fn.fnamemodify(flask_app, ":t"), -- Get filename only
            FLASK_ENV = "development",
            FLASK_DEBUG = "1",
            PYTHONPATH = workspace_folder,
          },
          args = {},
          stopOnEntry = false,
          redirectOutput = true,
          showReturnValue = true,
          postDebugTask = "",
          debugOptions = {
            "RedirectOutput",
            "DebugStdLib",
            "ShowReturnValue",
            "Django",
          },
        })

        -- Add error listener
        dap.listeners.after.event_error["flask-error"] = function(session, body)
          vim.notify(
            string.format("Debug error: %s\nTrace: %s", vim.inspect(body), vim.inspect(session.current_frame)),
            vim.log.levels.ERROR
          )
        end
      end

      -- Configure CodeLLDB for C++ debugging
      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
          command = "codelldb",
          args = { "--port", "${port}" },
        },
      }

      -- C++ debug configurations
      dap.configurations.cpp = {
        {
          name = "Launch file",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
        {
          name = "Attach to gdbserver :1234",
          type = "codelldb",
          request = "attach",
          host = "localhost",
          port = 1234,
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
        },
      }

      -- Setup Python debug adapter
      local python_path = get_python_path()

      -- Function to check and install debugpy
      local function ensure_debugpy()
        local venv_path = os.getenv("VIRTUAL_ENV")
        if venv_path then
          local debugpy_check = vim.fn.system(python_path .. " -c 'import debugpy'")
          if vim.v.shell_error ~= 0 then
            vim.notify("Installing debugpy in virtual environment...", vim.log.levels.INFO)
            local install_cmd = python_path .. " -m pip install debugpy"
            local result = vim.fn.system(install_cmd)
            if vim.v.shell_error ~= 0 then
              vim.notify("Failed to install debugpy: " .. result, vim.log.levels.ERROR)
              return false
            end
            vim.notify("debugpy installed successfully", vim.log.levels.INFO)
          end
          return true
        end
        return false
      end

      -- Ensure debugpy is installed before setting up debug adapter
      if ensure_debugpy() then
        require("dap-python").setup(python_path)
      else
        vim.notify("Please activate your virtual environment and try again", vim.log.levels.ERROR)
      end

      -- Python debug configurations
      dap.configurations.python = {
        {
          type = "python",
          request = "launch",
          name = "Python: Current File",
          program = "${file}",
          pythonPath = python_path,
          console = "integratedTerminal",
        },
        {
          type = "python",
          request = "launch",
          name = "Python: Django",
          program = "${workspaceFolder}/manage.py",
          args = { "runserver", "--noreload" },
          django = true,
          pythonPath = python_path,
        },
        {
          type = "python",
          request = "launch",
          name = "Python: Flask",
          module = "flask",
          args = { "run", "--no-debugger", "--no-reload" },
          env = {
            FLASK_APP = "app.py",
            FLASK_DEBUG = "1",
          },
          pythonPath = python_path,
          console = "integratedTerminal",
        },
      }

      -- Use same configurations for C
      dap.configurations.c = dap.configurations.cpp

      -- Setup JavaScript/React debugging
      require("dap-vscode-js").setup({
        debugger_path = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter",
        adapters = { "chrome", "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
      })

      -- Configure JavaScript/TypeScript debugging
      for _, language in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact" }) do
        dap.configurations[language] = {
          -- Debug Vite React application
          {
            type = "pwa-chrome",
            request = "launch",
            name = "Debug Vite React App (Chrome)",
            url = "http://localhost:5173", -- Default Vite dev server port
            webRoot = "${workspaceFolder}",
            sourceMaps = true,
            protocol = "inspector",
            sourceMapPathOverrides = {
              -- Vite specific source map overrides
              ["/@fs/*"] = "${workspaceFolder}/*",
              ["/@vite/client"] = "${workspaceFolder}/node_modules/@vite/client",
              ["/src/*"] = "${workspaceFolder}/src/*",
              ["*"] = "${workspaceFolder}/*",
            },
          },
          -- Attach to existing Vite React process
          {
            type = "pwa-chrome",
            request = "attach",
            name = "Attach to Vite React Process",
            url = "http://localhost:5173",
            webRoot = "${workspaceFolder}",
            sourceMaps = true,
            protocol = "inspector",
            sourceMapPathOverrides = {
              ["/@fs/*"] = "${workspaceFolder}/*",
              ["/@vite/client"] = "${workspaceFolder}/node_modules/@vite/client",
              ["/src/*"] = "${workspaceFolder}/src/*",
              ["*"] = "${workspaceFolder}/*",
            },
          },
          -- Debug React web application
          {
            type = "pwa-chrome",
            request = "launch",
            name = "Debug React App (Chrome)",
            url = "http://localhost:3000",
            webRoot = "${workspaceFolder}",
            userDataDir = false,
            sourceMaps = true,
            protocol = "inspector",
            sourceMapPathOverrides = {
              -- Add source map path overrides for different framework configurations
              ["webpack:///./~/*"] = "${workspaceFolder}/node_modules/*",
              ["webpack:///./*"] = "${workspaceFolder}/*",
              ["webpack:///*"] = "*",
              ["webpack:///src/*"] = "${workspaceFolder}/src/*",
            },
          },
          -- Attach to existing React process
          {
            type = "pwa-chrome",
            request = "attach",
            name = "Attach to React Process (Chrome)",
            processId = require("dap.utils").pick_process,
            webRoot = "${workspaceFolder}",
            sourceMaps = true,
            protocol = "inspector",
          },
          -- Debug Create-React-App
          {
            type = "pwa-chrome",
            request = "launch",
            name = "Debug CRA Tests",
            sourceMaps = true,
            protocol = "inspector",
            runtimeExecutable = "${workspaceFolder}/node_modules/.bin/react-scripts",
            runtimeArgs = {
              "test",
              "--runInBand",
              "--no-cache",
              "--watchAll=false",
            },
            rootPath = "${workspaceFolder}",
            cwd = "${workspaceFolder}",
            console = "integratedTerminal",
            internalConsoleOptions = "neverOpen",
          },
          -- Debug Next.js
          {
            type = "pwa-node",
            request = "launch",
            name = "Debug Next.js",
            cwd = "${workspaceFolder}",
            runtimeExecutable = "npm",
            runtimeArgs = { "run", "dev" },
            sourceMaps = true,
            protocol = "inspector",
            skipFiles = { "<node_internals>/**" },
            console = "integratedTerminal",
          },
        }
      end

      -- DAP UI setup
      dapui.setup()

      -- Automatically open/close DAP UI
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      -- Expose utility functions globally
      _G.compile_and_debug_cpp_file = compile_and_debug_cpp_file
      _G.debug_python_file = debug_python_file
      _G.debug_flask_app = debug_flask_app
      _G.debug_rq_worker = debug_rq_worker
      _G.get_python_path = get_python_path
    end,

    -- Keymaps for Debugging
    keys = {
      -- Breakpoints and Navigation
      {
        "<leader>db",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "Toggle Breakpoint",
      },
      {
        "<leader>dc",
        function()
          require("dap").continue()
        end,
        desc = "Continue",
      },
      {
        "<leader>do",
        function()
          require("dap").step_over()
        end,
        desc = "Step Over",
      },
      {
        "<leader>di",
        function()
          require("dap").step_into()
        end,
        desc = "Step Into",
      },
      {
        "<leader>dw",
        function()
          require("dapui").float_element("scopes", {
            enter = true,
            width = 50, -- Width of the floating window
            height = 20, -- Height of the floating window
            position = "center", -- Position of the floating window (can be 'center', 'left', 'right')
            title = "Debug Watches", -- Title of the floating window
          })
        end,
        desc = "Debugger Watches",
      },

      -- Stop Debugging Keymaps
      {
        "<leader>dx",
        function()
          require("dap").terminate()
          require("dapui").close()
        end,
        desc = "Terminate Debug Session",
      },
      {
        "<leader>dr",
        function()
          require("dap").restart()
        end,
        desc = "Restart Debugging",
      },
      {
        "<leader>dp",
        function()
          require("dap").pause()
        end,
        desc = "Pause Debugging",
      },

      -- Language-Specific Debug Launchers
      {
        "<leader>dgr",
        function()
          require("dap").continue({
            type = "pwa-chrome",
            request = "launch",
            name = "Debug Vite React App (Chrome)",
            url = "http://localhost:5173",
            webRoot = "${workspaceFolder}",
            sourceMaps = true,
          })
        end,
        desc = "Debug Vite React Application",
      },
      {
        "<leader>dga",
        function()
          require("dap").continue({
            type = "pwa-chrome",
            request = "attach",
            name = "Attach to React Process",
            processId = require("dap.utils").pick_process,
            webRoot = "${workspaceFolder}",
          })
        end,
        desc = "Attach to React Process",
      },
      {
        "<leader>dgc",
        function()
          _G.compile_and_debug_cpp_file()
        end,
        desc = "Compile and Debug C++ File",
      },
      {
        "<leader>dgp",
        function()
          _G.debug_python_file()
        end,
        desc = "Debug Current Python File",
      },
      {
        "<leader>dgf",
        function()
          _G.debug_flask_app()
        end,
        desc = "Debug Flask Application",
      },
      {
        "<leader>dgq",
        function()
          _G.debug_rq_worker()
        end,
        desc = "Debug RQ Worker",
      },
    },
  },
}
