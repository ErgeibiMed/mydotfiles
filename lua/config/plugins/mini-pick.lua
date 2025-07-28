return
{
    'echasnovski/mini.pick',
    version = '*',
    config = function()
        require('mini.pick').setup({})
            vim.keymap.set("n","<leader>ff",":Pick files<CR>")
    end
        

}
