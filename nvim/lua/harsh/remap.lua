-- Set mapleader to space
vim.g.mapleader = " "

-- Map leader-pv to execute Ex command
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex) -- Execute Ex command

-- Visual mode mappings to move lines up and down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv") -- Move selected lines down
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv") -- Move selected lines up

-- Normal mode mappings for moving lines up and down
vim.keymap.set("n", "J", "mzJ`z")       -- Move current line down
vim.keymap.set("n", "<C-d>", "<C-d>zz") -- Move cursor down and center
vim.keymap.set("n", "<C-u>", "<C-u>zz") -- Move cursor up and center
vim.keymap.set("n", "n", "nzzzv")       -- Move to next search result and center
vim.keymap.set("n", "N", "Nzzzv")       -- Move to previous search result and center

-- Greatest remap ever: Delete and paste in normal mode
vim.keymap.set("x", "<leader>p", [["_dP]]) -- Delete and paste in normal mode

-- Another great remap for copying to system clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]]) -- Yank to system clipboard
vim.keymap.set("n", "<leader>Y", [["+Y]])          -- Yank to system clipboard (line)

-- Delete without yanking
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]]) -- Delete without yanking

-- Escape key in insert mode
vim.keymap.set("i", "<C-c>", "<Esc>") -- Map Ctrl-c to Escape in insert mode

-- Disable mapping for Q
vim.keymap.set("n", "Q", "<nop>") -- No operation for Q

-- Create a new tmux window with tmux-sessionizer
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>") -- Open tmux-sessionizer in a new tmux window

-- LSP format command
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format) -- Format code with LSP

-- Quickfix list navigation
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")     -- Go to next quickfix result and center
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")     -- Go to previous quickfix result and center
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz") -- Go to next location list result and center
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz") -- Go to previous location list result and center

-- Search and replace
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]]) -- Search and replace in current file

-- Add execute permissions to the current file
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true }) -- Add execute permissions to the current file

-- Edit Packer config
vim.keymap.set("n", "<leader>vpp", "<cmd>e ~/.config/nvim/lua/harsh/packer.lua<CR>") -- Edit Packer config file

-- Run CellularAutomaton make_it_rain command
vim.keymap.set("n", "<leader>mr", "<cmd>CellularAutomaton make_it_rain<CR>") -- Run make_it_rain command from CellularAutomaton

-- Reload current file
vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd("so") -- Reload current file
end)

vim.keymap.set('n', '<leader>vs', '<cmd>VenvSelect<cr>')
-- Keymap to retrieve the venv from a cache (the one previously used for the same project directory).
vim.keymap.set('n', '<leader>vc', '<cmd>VenvSelectCached<cr>')
-- Create shortcuts for RestNvim plugin
vim.api.nvim_set_keymap('n', '<Leader>r', '<Plug>RestNvim', {})
vim.api.nvim_set_keymap('n', '<Leader>rp', '<Plug>RestNvimPreview', {})
vim.api.nvim_set_keymap('n', '<Leader>rl', '<Plug>RestNvimLast', {})
