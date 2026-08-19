return {
  -- Ghostly transparent theme
  {
    "folke/tokyonight.nvim",
    opts = {
      style = "night",
      transparent = true,
      terminal_colors = true,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        functions = {},
        variables = {},
        sidebars = "transparent",
        floats = "transparent",
      },
      on_colors = function(colors)
        -- Keep original colors for blending calculations
      end,
      on_highlights = function(highlights, colors)
        highlights.Normal = { bg = "NONE" }
        highlights.NormalFloat = { bg = "NONE" }
        highlights.FloatBorder = { bg = "NONE" }
        highlights.Pmenu = { bg = "NONE" }
        highlights.PmenuSel = { bg = colors.bg_highlight }
        highlights.TelescopeNormal = { bg = "NONE" }
        highlights.TelescopeBorder = { bg = "NONE" }
        highlights.NeoTreeNormal = { bg = "NONE" }
        highlights.NeoTreeNormalNC = { bg = "NONE" }
        highlights.WhichKeyFloat = { bg = "NONE" }
        highlights.LazyNormal = { bg = "NONE" }
        highlights.MasonNormal = { bg = "NONE" }
      end,
    },
  },

  -- Configure LazyVim to use the ghostly theme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight-night",
    },
  },

  -- Make telescope ghostly
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        winblend = 10,
        layout_config = {
          prompt_position = "top",
        },
        sorting_strategy = "ascending",
      },
    },
  },

  -- Transparent which-key
  {
    "folke/which-key.nvim",
    opts = {
      window = {
        winblend = 10,
      },
    },
  },

  -- Transparent neo-tree
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      window = {
        winblend = 10,
      },
    },
  },
}