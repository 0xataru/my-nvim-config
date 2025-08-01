return {
  {
    -- "projekt0n/github-nvim-theme",
    -- "sainnhe/gruvbox-material",
    -- "catppuccin/nvim",
    -- "rebelot/kanagawa.nvim",
    "EdenEast/nightfox.nvim",
    -- "rose-pine/neovim",
    -- "olimorris/onedarkpro.nvim",
    -- "navarasu/onedark.nvim",
    -- "tiagovla/tokyodark.nvim",
    -- "Mofiqul/vscode.nvim",
    -- "folke/tokyonight.nvim",
    priority = 1000,
    config = function()
      -- vim.cmd("colorscheme github_dark_default")
      -- vim.cmd("colorscheme gruvbox-material")
      -- vim.cmd("colorscheme catppuccin-macchiato")
      -- vim.cmd("colorscheme tokyonight-night")
      -- vim.cmd("colorscheme kanagawa")
      vim.cmd("colorscheme carbonfox")
      -- vim.cmd("colorscheme rose-pine")
      -- vim.cmd("colorscheme onedark")
      -- vim.cmd("colorscheme tokyodark")
      -- vim.cmd("colorscheme vscode")

      -- transparent background
      vim.cmd([[
        highlight Normal guibg=NONE ctermbg=NONE
        highlight NonText guibg=NONE ctermbg=NONE

        highlight NeoTreeNormal guibg=NONE ctermbg=NONE
        highlight NeoTreeFloatNormal guibg=NONE ctermbg=NONE
        highlight NeoTreeEndOfBuffer guibg=NONE ctermbg=NONE
        highlight NeoTreeCursorLine guibg=NONE ctermbg=NONE

        highlight VertSplit guibg=NONE ctermbg=NONE
        highlight SignColumn guibg=NONE ctermbg=NONE
        highlight EndOfBuffer guibg=NONE ctermbg=NONE
        highlight LineNr guibg=NONE ctermbg=NONE
        highlight CursorLineNr guibg=NONE ctermbg=NONE
        highlight Pmenu guibg=NONE ctermbg=NONE
        highlight PmenuSel guibg=NONE ctermbg=NONE
        highlight FloatBorder guibg=NONE ctermbg=NONE
        highlight NormalFloat guibg=NONE ctermbg=NONE
        highlight StatusLine guibg=NONE ctermbg=NONE
        highlight StatusLineNC guibg=NONE ctermbg=NONE
        highlight TabLine guibg=NONE ctermbg=NONE
        highlight TabLineFill guibg=NONE ctermbg=NONE
        highlight TabLineSel guibg=NONE ctermbg=NONE
        highlight WinSeparator guibg=NONE ctermbg=NONE
      ]])
      -- you may delete the part until here if you don't want transparent background
    end,
  },
}
