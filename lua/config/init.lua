require("config.set")
require("config.remap")
require("config.lazy_init")


vim.diagnostic.config(
    {
        virtual_text =
        { current_line = true }
    }

)

vim.keymap.set("n", "<leader>pv", "<cmd>Ex<CR>")


local augroup = vim.api.nvim_create_augroup
local TheMoGroup = augroup('TheMo', {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup('HighlightYank', {})

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


--------------------------- --  default ones fron neovim---------------------------------------------------------
                         --    grn in Normal mode maps to vim.lsp.buf.rename()
                         --    grr in Normal mode maps to vim.lsp.buf.references()
                         --    gri in Normal mode maps to vim.lsp.buf.implementation()
                         --    gO in Normal mode maps to vim.lsp.buf.document_symbol()
			 --    (this is analogous to the gO mappings in help buffers
--                                and :Man page buffers to show a “table of contents”)
                         --    gra in Normal and Visual mode maps to vim.lsp.buf.code_action()
                         --    CTRL-S in Insert and Select mode maps to vim.lsp.buf.signature_help()
                         --    [d and ]d move between diagnostics in the current buffer
--                        --([D jumps to the first diagnostic, ]D jumps to the last)
-------------------------------------------------------------------------------------------------------------------------------
                         --  mine
--------------------------------
                    ----autocmd('LspAttach', {
                    ----    group = TheMoGroup,
                    ----    callback = function(e)
                    ----        local opts = { buffer = e.buf }
                    ----        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
                    ----        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
                    ----        vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
                    ----        vim.keymap.set("n", "gdw", function() vim.diagnostic.open_float() end, opts)
                    ----        vim.keymap.set("n", "<leader>ca", function() vim.lsp.buf.code_action() end, opts)
                    ----        --vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
                    ----        --vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
                    ----        vim.keymap.set("i", "gsh", function() vim.lsp.buf.signature_help() end, opts)
                    ----        vim.keymap.set("n", "gdn", function() vim.diagnostic.goto_next() end, opts)
                    ----        vim.keymap.set("n", "gdp", function() vim.diagnostic.goto_prev() end, opts)
                    ----    end
                    ----})
-------------------------------------------------------------------------------------------------------------------------------

-----------------------------diagnostic------------------------------------------------------------------
vim.keymap.set('n', '<leader>gd', vim.diagnostic.open_float)
vim.keymap.set('n', 'gdn', vim.diagnostic.goto_prev)
vim.keymap.set('n', 'gdp', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)
-- -------------------------------------------------------------------------------------------------------
--
-- Use LspAttach autocommand to only map the following keys----------------------------------------------
-- after the language server attaches to the current buffer----------------------------------------------
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        -- Enable completion triggered by <c-x><c-o>
        -- vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
        --vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
        --vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
        --vim.keymap.set('n', '<space>wl', function()
        --  print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        --end, opts)
        vim.keymap.set('n', '<leader>tdf', vim.lsp.buf.type_definition, opts)
        vim.keymap.set('n', 'grn', vim.lsp.buf.rename, opts)
        vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', 'grr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', '<space>f', function()
            vim.lsp.buf.format { async = true }
        end, opts)
    end
}
)

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
