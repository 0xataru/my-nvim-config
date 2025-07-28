return {
  "terryma/vim-multiple-cursors",
  event = "VeryLazy",
  init = function()
    vim.g.multi_cursor_use_default_mapping = 0
    vim.g.multi_cursor_start_word_key = '<C-n>'
    vim.g.multi_cursor_select_all_word_key = '<C-m>'
    vim.g.multi_cursor_start_key = 'g<C-n>'
    vim.g.multi_cursor_select_all_key = 'g<C-m>'
    vim.g.multi_cursor_next_key = '<C-n>'
    vim.g.multi_cursor_prev_key = '<C-p>'
    vim.g.multi_cursor_skip_key = '<C-x>'
    vim.g.multi_cursor_quit_key = '<Esc>'
  end,
  keys = {
    -- Main commands for multicursor
    { "<C-n>", "<Plug>(multiple-cursors-normal)", mode = "n", desc = "Add cursor at next occurrence" },
    { "<C-p>", "<Plug>(multiple-cursors-prev)", mode = "n", desc = "Add cursor at previous occurrence" },
    { "<C-s>", "<Plug>(multiple-cursors-skip)", mode = "n", desc = "Skip current occurrence" },
    { "<C-x>", "<Plug>(multiple-cursors-skip-all)", mode = "n", desc = "Skip all occurrences" },
    
    -- Visual mode
    { "<C-n>", "<Plug>(multiple-cursors-visual)", mode = "v", desc = "Add cursor for each selected line" },
  },
}