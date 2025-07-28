require("config.set")
require("config.remap")
require("config.lazy_init")


vim.diagnostic.config(
    {
        virtual_text =
        { current_line = true }
    }

)


vim.keymap.set("n", "<leader>pv", "<CMD>Oil<CR>", { desc = "Open parent directory" })


vim.api.nvim_create_autocmd("BufWritePre", {
    callback = function()
        local mode = vim.api.nvim_get_mode().mode
        local filetype = vim.bo.filetype
        if vim.bo.modified == true and mode == 'n' and filetype ~= "oil" then
            vim.cmd('lua vim.lsp.buf.format()')
        else
        end
    end
})

local augroup = vim.api.nvim_create_augroup
local TheMoGroup = augroup('TheMo', {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup('HighlightYank', {})

--function R(name)
--   require("plenary.reload").reload_module(name)
--end

--vim.filetype.add({
--   extension = {
--      templ = 'templ',
-- }
--})

autocmd('TextYankPost', {
    group = yank_group,
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({
            higroup = 'IncSearch',
            timeout = 40,
        })
    end,
})

autocmd({ "BufWritePre" }, {
    group = TheMoGroup,
    pattern = "*",
    command = [[%s/\s\+$//e]],
})

--
--  default ones fron neovim
--    grn in Normal mode maps to vim.lsp.buf.rename()
--    grr in Normal mode maps to vim.lsp.buf.references()
--    gri in Normal mode maps to vim.lsp.buf.implementation()
--    gO in Normal mode maps to vim.lsp.buf.document_symbol() (this is analogous to the gO mappings in help buffers and :Man page buffers to show a “table of contents”)
--    gra in Normal and Visual mode maps to vim.lsp.buf.code_action()
--    CTRL-S in Insert and Select mode maps to vim.lsp.buf.signature_help()
--    [d and ]d move between diagnostics in the current buffer ([D jumps to the first diagnostic, ]D jumps to the last)
--
--  mine
--
autocmd('LspAttach', {
    group = TheMoGroup,
    callback = function(e)
        local opts = { buffer = e.buf }
        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
        vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
        vim.keymap.set("n", "gdw", function() vim.diagnostic.open_float() end, opts)
        vim.keymap.set("n", "<leader>ca", function() vim.lsp.buf.code_action() end, opts)
        --vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
        --vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
        vim.keymap.set("i", "gsh", function() vim.lsp.buf.signature_help() end, opts)
        vim.keymap.set("n", "gdn", function() vim.diagnostic.goto_next() end, opts)
        vim.keymap.set("n", "gdp", function() vim.diagnostic.goto_prev() end, opts)
    end
})

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
