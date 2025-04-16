-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- set leader key to space
vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

---------------------
-- General Keymaps -------------------

-- use jk to exit insert mode
keymap.set("i", "jj", "<ESC>", { desc = "Exit insert mode with jk" })
keymap.set("n", "<leader>q", ":qall<CR>", { desc = "Exit Vim" })
keymap.set("i", "<D-s>", "<ESC>:w<CR>", { desc = "Save file in insert mode" })
keymap.set("v", "<D-s>", "<ESC>:w<CR>", { desc = "Save file in visual mode" })
keymap.set("n", "<D-s>", ":w<CR>", { desc = "Save file in normal mode" })

-- clear search highlights
keymap.set("n", "<leader>h", ":nohl<CR>", { desc = "Clear search highlights" })

-- delete single character without copying into register
keymap.set("n", "x", '"_x')

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- increment
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

keymap.set("n", "<leader>bd", ":bdelete<CR>", { desc = "Close current tab" }) -- close current tab
keymap.set("n", "<S-l>", ":BufferLineCycleNext<CR>", { desc = "Go to next tab" }) --  go to next tab
keymap.set("n", "<S-h>", ":BufferLineCyclePrev<CR>", { desc = "Go to previous tab" }) --  go to previous tab

-- move lines up and down
-- normal mode
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", { noremap = true, silent = true })
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", { noremap = true, silent = true })
-- visual mode
vim.keymap.set("x", "<A-j>", ":move '>+1<CR>gv=gv", { noremap = true, silent = true })
vim.keymap.set("x", "<A-k>", ":move '<-2<CR>gv=gv", { noremap = true, silent = true })

-- Duplicate lines
vim.keymap.set("v", "<D-C-Up>", "y`>p`<", { silent = true })
vim.keymap.set("n", "<D-C-Up>", "Vy`>p`<", { silent = true })
vim.keymap.set("v", "<D-C-Down>", "y`<kp`>", { silent = true })
vim.keymap.set("n", "<D-C-Down>", "Vy`<p`>", { silent = true })

-- delete a word by alt+backspace
vim.keymap.set({ "i", "c" }, "<A-BS>", "<C-w>", { noremap = true })
vim.keymap.set("n", "<A-BS>", "db", { noremap = true })

-- clear line with cd
vim.keymap.set("n", "cd", "0D", {})

-- copilot keymaps
keymap.set("n", "<leader>te", ":Copilot enable<CR>", { noremap = true, silent = false })
keymap.set("n", "<leader>td", ":Copilot disable<CR>", { noremap = true, silent = false })
keymap.set("n", "<leader>ts", ":Copilot status<CR>", { noremap = true, silent = false })
