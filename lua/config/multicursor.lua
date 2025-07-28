-- User settings for multicursor
local M = {}

-- Function to create cursors on multiple lines
function M.create_cursors_on_lines()
  -- Get current cursor position
  local current_line = vim.api.nvim_win_get_cursor(0)[1]
  
  -- Ask user for line range
  local start_line = vim.fn.input("Start line (default: current): ")
  if start_line == "" then
    start_line = current_line
  else
    start_line = tonumber(start_line)
  end
  
  local end_line = vim.fn.input("End line (default: current): ")
  if end_line == "" then
    end_line = current_line
  else
    end_line = tonumber(end_line)
  end
  
  -- Create cursors on each line in the range
  for line = start_line, end_line do
    -- Move to the line and create a cursor
    vim.api.nvim_win_set_cursor(0, {line, 0})
    vim.cmd("normal! g<C-n>")
  end
  
  -- Return to the original position
  vim.api.nvim_win_set_cursor(0, {current_line, 0})
end

-- Function to create cursors on words
function M.create_cursors_on_words()
  local word = vim.fn.input("Word to find: ")
  if word ~= "" then
    -- Search for all occurrences of the word and create cursors
    vim.cmd("normal! /" .. word .. "<CR>")
    vim.cmd("normal! g<C-n>")
  end
end

-- Register user commands
vim.api.nvim_create_user_command("MultiCursorLines", M.create_cursors_on_lines, {})
vim.api.nvim_create_user_command("MultiCursorWords", M.create_cursors_on_words, {})

-- Add additional hotkeys
local keymap = vim.keymap.set

-- Hotkeys for multicursor
keymap("n", "<leader>mc", "<cmd>MultiCursorLines<CR>", { desc = "Create cursors on lines" })
keymap("n", "<leader>mw", "<cmd>MultiCursorWords<CR>", { desc = "Create cursors on words" })

-- Alternative hotkeys for quick access (use standard vim-multiple-cursors keys)
keymap("n", "<C-d>", "<Plug>(multiple-cursors-normal)", { desc = "Add cursor at next occurrence" })
keymap("v", "<C-d>", "<Plug>(multiple-cursors-visual)", { desc = "Add cursor for each selected line" })

return M