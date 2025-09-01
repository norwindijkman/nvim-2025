return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  {
    'gorbit99/codewindow.nvim',
    config = function()
      local codewindow = require('codewindow')
      codewindow.setup {
        screen_bounds = 'background',
        window_border = 'none',
      }
    end,
  },

  {
    'lewis6991/satellite.nvim',
    config = function()
      local satellite = require('satellite')
      satellite.setup()
    end,
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    enabled = false,
  },

  {
    "nvim-telescope/telescope.nvim",
    opts = function()
      local conf = require "nvchad.configs.telescope"
      local telescope_harpoon = require "custom.telescope_harpoon"
      local actions = require "telescope.actions"

      conf.defaults.mappings.i = {
        ["<TAB>"] = telescope_harpoon.mark_file,
        ["<C-a>"] = actions.cycle_previewers_prev,
        ["<C-s>"] = actions.cycle_previewers_next,
      }

      conf.pickers = {
        git_commits = {
          previewer = require("telescope.previewers").new_termopen_previewer {
            get_command = function(entry)
              local commit = entry.value
              -- Use git show to include author, date, and the diff
              return {
                "git",
                "--no-pager",
                "show",
                "--pretty=format:Commit: %H%nAuthor: %an <%ae>%nDate:   %ad%n%n%s%n%b",
                commit,
              }
            end,
          },
        },
        git_status = {
          mappings = {
            i = {
              ["<TAB>"] = telescope_harpoon.mark_file,
            },
          },
        },
      }

      return conf
    end,
  },

  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    opts = function()
      local conf = require "nvchad.configs.nvimtree"
      conf.actions = { open_file = { quit_on_open = true } }
      conf.renderer.icons.glyphs.git = {
        unstaged = "󰏫",
        staged = "✓",
        unmerged = "",
        renamed = "󰏫",
        untracked = "󰙴",
        deleted = "",
        ignored = "◌",
      }
    end,
  },

  {
    "mbbill/undotree",
    lazy = false,
  },

  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require "harpoon"
      harpoon:setup {}
    end,
  },

  {
    "lewis6991/gitsigns.nvim",
    event = "User FilePost",
    config = function()
      require("gitsigns").setup {
        current_line_blame = true,
        signs_staged_enable = true,
        signs_staged = {
          add = { text = "󰙴" },
          change = { text = "󰏫" },
          delete = { text = "-" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
          untracked = { text = "󰙴" },
        },
      }
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      disable = { "text" },
      ensure_installed = {
        "vim",
        "lua",
        "html",
        "css",
        "javascript",
        "typescript",
        "tsx",
        "svelte",
        "c",
        "c_sharp",
        "php",
        "twig",
        "markdown",
        "markdown_inline",
        "dart",
        "java",
      },
      indent = {
        enable = true,
      },
    },
  },

  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    opts = function()
      local conf = require "nvchad.configs.nvimtree"
      conf.view.width = vim.o.columns
      conf.actions.open_file.quit_on_open = true
      conf.renderer.icons.glyphs.git = {
        unstaged = "󰏫",
        staged = "✓",
        unmerged = "",
        renamed = "󰏫",
        untracked = "󰙴",
        deleted = "",
        ignored = "◌",
      }
    end,
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    enabled = false,
  },

  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- lua stuff
        "lua-language-server",
        "stylua",

        -- web dev stuff
        "css-lsp",
        "html-lsp",
        "ts_ls",
        "sonarlint-language-server",
        "svelte-language-server",
        "deno",
        "prettier",
        "marksman",

        -- java stuff
        "jdtls",

        -- php stuff
        "phpactor",
        "twig-cs-fixer",

        -- c/cpp stuff
        "clangd",
        "clang-format",

        -- c# stuff
        "omnisharp",
      },
    },
  },

  -- {
  --   url = "https://gitlab.com/schrieveslaach/sonarlint.nvim",
  --   ft = { "typescriptreact" },
  --   dependencies = {
  --     "williamboman/mason.nvim",
  --   },
  --   config = function()
  --     require("sonarlint").setup {
  --       server = {
  --         cmd = {
  --           vim.fn.expand "$MASON/bin/sonarlint-language-server",
  --           "-stdio",
  --           "-analyzers",
  --           vim.fn.expand "$MASON/share/sonarlint-analyzers/sonarjs.jar",
  --           vim.fn.expand "$MASON/share/sonarlint-analyzers/sonarhtml.jar",
  --         },
  --       },
  --       filetypes = {
  --         "typescriptreact",
  --       },
  --     }
  --   end,
  -- },
  --

  {
    "L3MON4D3/LuaSnip",
    config = function()
      require("luasnip.loaders.from_snipmate").lazy_load { paths = vim.fn.stdpath "config" .. "/snippets" }
    end,
  },
}
