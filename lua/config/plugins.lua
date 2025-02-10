return {
  {
    "ishan9299/nvim-solarized-lua",
    lazy = false,  -- Load during startup
    priority = 1000,  -- Load this before other plugins
    config = function()
      -- Set background to dark
      vim.opt.background = 'dark'
      -- Load the colorscheme
      vim.cmd([[colorscheme solarized]])
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "lua", "vim", "python" },
        highlight = { enable = true },
      })
    end
  },
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local telescope = require("telescope")
      telescope.setup({
          -- TODO
      })
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
          -- TODO
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      -- TODO
    end,
  },
}
