-- C/C++ specific configuration and workflow
return {
  -- Enhanced clangd features
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- clangd extensions for enhanced C++ features
      {
        "p00f/clangd_extensions.nvim",
        lazy = true,
        config = function() end,
        opts = {
          inlay_hints = {
            inline = false,
          },
        },
      },
    },
    opts = function(_, opts)
      -- Set up clangd server configuration
      if not opts.servers then
        opts.servers = {}
      end

      -- Initialize clangd config if it doesn't exist (in case LazyVim hasn't loaded it yet)
      if not opts.servers.clangd then
        opts.servers.clangd = {}
      end

      -- Override/merge clangd configuration
      opts.servers.clangd = vim.tbl_deep_extend("force", opts.servers.clangd, {
        -- Empty keys array disables LazyVim's default ,ch keybinding
        keys = {},
        -- Completely replace cmd array to ensure our flags are used
        -- NOTE: This replaces LazyVim's cmd to fix --function-arg-placeholders issue
        cmd = {
          "clangd",
          "--background-index",
          "--path-mappings=/mnt/c/=C:/,/mnt/d/=D:/",  -- WSL: Map client paths (/mnt/*) to server paths (C:/)
          "--clang-tidy",
          "--header-insertion=iwyu",
          "--completion-style=detailed",
          "--function-arg-placeholders=true",  -- Fixed: LazyVim uses flag without value
          "--fallback-style=llvm",
          "--all-scopes-completion",
          "--header-insertion-decorators",
        },
        capabilities = {
          offsetEncoding = { "utf-16" },
          -- Disable features that fail when compile_commands.json path mapping doesn't work
          textDocument = {
            documentHighlight = { dynamicRegistration = false },
            foldingRange = { dynamicRegistration = false },
          },
        },
      })

      -- Setup handler for clangd to initialize clangd_extensions
      -- This is required for ClangdSwitchSourceHeader and other commands to work
      if not opts.setup then
        opts.setup = {}
      end

      opts.setup.clangd = function(_, server_opts)
        -- Get clangd_extensions config
        local clangd_ext_opts = LazyVim.opts("clangd_extensions.nvim")
        -- Initialize clangd_extensions with server options
        -- This sets up the LSP server AND registers clangd commands
        require("clangd_extensions").setup(
          vim.tbl_deep_extend("force", clangd_ext_opts or {}, { server = server_opts })
        )
        return false -- Don't do default LSP setup (clangd_extensions handles it)
      end

      -- Use LazyVim's on_attach system to add our custom keymaps
      -- This runs after LazyVim sets its keymaps, allowing us to override them
      LazyVim.lsp.on_attach(function(client, buffer)
        if client.name == "clangd" then
          local map_opts = { buffer = buffer, silent = true }

          -- Switch between header and implementation
          vim.keymap.set("n", "<leader>h", "<cmd>ClangdSwitchSourceHeader<cr>",
            vim.tbl_extend("force", map_opts, { desc = "Switch Header/Implementation" }))

          -- Open header/impl in vertical split
          vim.keymap.set("n", "<leader>vh", function()
            vim.cmd("vsplit")
            vim.cmd("ClangdSwitchSourceHeader")
          end, vim.tbl_extend("force", map_opts, { desc = "Open Header/Impl in Vertical Split" }))

          -- Open header/impl in horizontal split
          vim.keymap.set("n", "<leader>sh", function()
            vim.cmd("split")
            vim.cmd("ClangdSwitchSourceHeader")
          end, vim.tbl_extend("force", map_opts, { desc = "Open Header/Impl in Horizontal Split" }))

          -- Open header/impl in new tab
          vim.keymap.set("n", "<leader>th", function()
            vim.cmd("tabnew")
            vim.cmd("ClangdSwitchSourceHeader")
          end, vim.tbl_extend("force", map_opts, { desc = "Open Header/Impl in New Tab" }))

          -- Symbol info (useful for C++ templates and overloads)
          vim.keymap.set("n", "<leader>si", "<cmd>ClangdSymbolInfo<cr>",
            vim.tbl_extend("force", map_opts, { desc = "Symbol Info" }))

          -- Type hierarchy
          vim.keymap.set("n", "<leader>ty", "<cmd>ClangdTypeHierarchy<cr>",
            vim.tbl_extend("force", map_opts, { desc = "Type Hierarchy" }))
        end
      end)

      return opts
    end,
  },

  -- CMake integration
  {
    "Shatur/neovim-cmake",
    ft = { "c", "cpp", "cmake" },
    keys = {
      { "<leader>cg", "<cmd>CMakeGenerate<cr>", desc = "CMake Generate", ft = { "c", "cpp" } },
      { "<leader>cb", "<cmd>CMakeBuild<cr>", desc = "CMake Build", ft = { "c", "cpp" } },
      { "<leader>cr", "<cmd>CMakeRun<cr>", desc = "CMake Run", ft = { "c", "cpp" } },
      { "<leader>cd", "<cmd>CMakeDebug<cr>", desc = "CMake Debug", ft = { "c", "cpp" } },
      { "<leader>ct", "<cmd>CMakeSelectBuildType<cr>", desc = "CMake Select Build Type", ft = { "c", "cpp" } },
      { "<leader>cc", "<cmd>CMakeClean<cr>", desc = "CMake Clean", ft = { "c", "cpp" } },
    },
    opts = {
      dap_configuration = {
        type = "codelldb",
      },
      build_dir = function()
        return "build"
      end,
    },
  },

  -- Debugging support (DAP)
  {
    "mfussenegger/nvim-dap",
    ft = { "c", "cpp" },
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-neotest/nvim-nio", -- Required by nvim-dap-ui
    },
    keys = {
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint", ft = { "c", "cpp" } },
      { "<leader>dc", function() require("dap").continue() end, desc = "Continue", ft = { "c", "cpp" } },
      { "<leader>di", function() require("dap").step_into() end, desc = "Step Into", ft = { "c", "cpp" } },
      { "<leader>do", function() require("dap").step_over() end, desc = "Step Over", ft = { "c", "cpp" } },
      { "<leader>dO", function() require("dap").step_out() end, desc = "Step Out", ft = { "c", "cpp" } },
      { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL", ft = { "c", "cpp" } },
      { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last", ft = { "c", "cpp" } },
      { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate", ft = { "c", "cpp" } },
      { "<leader>du", function() require("dapui").toggle() end, desc = "Toggle DAP UI", ft = { "c", "cpp" } },
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      -- Setup DAP UI
      dapui.setup({
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
      })

      -- Virtual text for variable values
      require("nvim-dap-virtual-text").setup()

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

      -- GDB/LLDB adapter configuration
      dap.adapters.gdb = {
        type = "executable",
        command = "gdb",
        args = { "-i", "dap" },
      }

      dap.adapters.lldb = {
        type = "executable",
        command = "lldb-vscode",
        name = "lldb",
      }

      -- C/C++ configurations
      dap.configurations.cpp = {
        {
          name = "Launch (GDB)",
          type = "gdb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopAtBeginningOfMainSubprogram = false,
        },
        {
          name = "Attach to process (GDB)",
          type = "gdb",
          request = "attach",
          processId = require("dap.utils").pick_process,
          cwd = "${workspaceFolder}",
        },
      }

      -- Share C++ config with C
      dap.configurations.c = dap.configurations.cpp
    end,
  },

  -- Better syntax highlighting for C/C++
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "c", "cpp", "cmake", "make" })
      end
    end,
  },
}
