require("config")


vim.cmd(":hi statusline guibg=NONE")

vim.api.nvim_set_option("clipboard", "unnamedplus")
vim.lsp.set_log_level('off')
