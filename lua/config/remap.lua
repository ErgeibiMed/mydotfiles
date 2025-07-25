vim.g.mapleader = " "



vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz") -- move down
vim.keymap.set("n", "<C-u>", "<C-u>zz") -- move up
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")


-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

vim.keymap.set("n", "Q", "<nop>")

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])


-- Disable arrows in every mode
vim.keymap.set("n", "<Up>", ":echoe 'Use vim motion for better experience!'<CR>")
vim.keymap.set("n", "<Down>", ":echoe 'Use vim motion for better experience!'<CR>")
vim.keymap.set("n", "<Left>", ":echoe 'Use vim motion for better experience!'<CR>")
vim.keymap.set("n", "<Right>", ":echoe 'Use vim motion for better experience!'<CR>")
vim.keymap.set("i", "<Up>", "<C-o>:echoe 'Use vim motion for better experience!'<CR>")
vim.keymap.set("i", "<Down>", "<C-o>:echoe 'Use vim motion for better experience!'<CR>")
vim.keymap.set("i", "<Left>", "<C-o>:echoe 'Use vim motion for better experience!'<CR>")
vim.keymap.set("i", "<Right>", "<C-o>:echoe 'Use vim motion for better experience!'<CR>")
vim.keymap.set("v", "<Up>", ":<C-u>echoe 'Use vim motion for better experience!'<CR>")
vim.keymap.set("v", "<Down>", ":<C-u>echoe 'Use vim motion for better experience!'<CR>")
vim.keymap.set("v", "<Left>", ":<C-u>echoe 'Use vim motion for better experience!'<CR>")
vim.keymap.set("v", "<Right>", ":<C-u>echoe 'Use vim motion for better experience!'<CR>")
