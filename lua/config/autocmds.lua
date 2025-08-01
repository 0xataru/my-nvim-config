-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Disable diagnostics for .env files
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "env" },
  callback = function()
    -- Diagnostics are not needed for .env files
    vim.diagnostic.enable(false)
  end,
})

-- Alternatively, disable diagnostics for files named .env
vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = { "*.env", ".env*" },
  callback = function()
    -- Diagnostics are not needed for .env files
    vim.diagnostic.enable(false)
  end,
})
