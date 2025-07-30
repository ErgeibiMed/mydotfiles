require("config")


vim.cmd(":hi statusline guibg=NONE")
vim.opt.completeopt = {'menu', 'menuone', 'noselect'}

vim.api.nvim_set_option("clipboard", "unnamedplus")
vim.lsp.set_log_level('off')

