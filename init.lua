require("config")


vim.cmd(":hi statusline guibg=NONE")
vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
        vim.hl.on_yank()
    end
})

vim.api.nvim_set_option('clipboard', 'unnamedplus')

vim.lsp.set_log_level('off')
--------------------------------- lsp stuff--------------------------------------------------------------------


-- -------------------------------------------------------------------------------------------------------
local function setup_lsp()
    local lsp_dir = vim.fn.stdpath("config") .. "/lsp"
    local lsp_servers = {}

    if vim.fn.isdirectory(lsp_dir) == 1 then
        for _, file in ipairs(vim.fn.readdir(lsp_dir)) do
            if file:match("%.lua$") and file ~= "init.lua" then
                local server_name = file:gsub("%.lua$", "")
                table.insert(lsp_servers, server_name)
            end
        end
    end

    vim.lsp.enable(lsp_servers)
end

setup_lsp()
-----------------------------diagnostic------------------------------------------------------------------

vim.diagnostic.config({ virtual_text = { current_line = true } })
vim.keymap.set('n', '<leader>gd', vim.diagnostic.open_float)
vim.keymap.set('n', 'gdn', vim.diagnostic.goto_prev)
vim.keymap.set('n', 'gdp', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)
-- -------------------------------------------------------------------------------------------------------
-- Use LspAttach autocommand to only map the following keys----------------------------------------------
-- after the language server attaches to the current buffer----------------------------------------------
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        -- Enable completion triggered by <c-x><c-o>
        -- vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        --local opts = { buffer = ev.buf }
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        -- Create a keymap for vim.lsp.buf.implementation ...
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
        print(opts)
        -- Enable auto-completion. Note: Use CTRL-Y to select an item. |complete_CTRL-Y|
        if client:supports_method('textDocument/completion') then
            -- Optional: trigger autocompletion on EVERY keypress. May be slow!
            local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
            client.server_capabilities.completionProvider.triggerCharacters = chars
            vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
        end
        -------------------------------- Auto-format ("lint") on save.
        -------------------------------- Usually not needed if server supports "textDocument/willSaveWaitUntil".
        if not client:supports_method('textDocument/willSaveWaitUntil')
            and client:supports_method('textDocument/formatting') then
            vim.api.nvim_create_autocmd('BufWritePre', {
                group = vim.api.nvim_create_augroup('my.lsp', { clear = false }),
                buffer = ev.buf,
                callback = function()
                    vim.lsp.buf.format({ bufnr = ev.buf, id = client.id, timeout_ms = 1000 })
                end,
            })
        end
    end,
}
)
