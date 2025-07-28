return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        { "hrsh7th/nvim-cmp", event = "InsertEnter" },
        --  "L3MON4D3/LuaSnip",
        {
            "L3MON4D3/LuaSnip",
            -- follow latest release.
            version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
            -- install jsregexp (optional!).
            build = "make install_jsregexp"
        },
        "saadparwaiz1/cmp_luasnip",
        "j-hui/fidget.nvim",
    },

    config = function()
        local cmp = require('cmp')
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities())

        require("fidget").setup({})
        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",
                "rust_analyzer",
                "gopls"
            },
            handlers = {
                -- function(server_name) -- default handler (optional)

                --     require("lspconfig")[server_name].setup {
                --         capabilities = capabilities
                --     }
                -- end,

                ["lua_ls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.lua_ls.setup {
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                diagnostics = {
                                    globals = { "vim", "it", "describe", "before_each", "after_each" },
                                }
                            }
                        }
                    }
                end,
                ["gopls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.gopls.setup {
                        capabilities = capabilities,
                        settings = {
                            go = {},
                        }
                    }
                end,

                ["clangd"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.clangd.setup {
                        capabilities = capabilities,
                        settings = {},
                    }
                end,

                ["rust_analyzer"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.rust_analyzer.setup {
                        capabilities = capabilities,
                        settings = {
                            rust = {
                            },
                        }
                    }
                end,
            }
        })
        local cmp_select = { behavior = cmp.SelectBehavior.Select, count = 1 }
        cmp.setup({
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                end,
            },
            formatting = {
                format = function(entry, vim_item)
                    vim_item.menu = nil
                    return vim_item
                end,
            },
            window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
            },
            --performance = {
            --    cmp.config.performance.max_view_entries== 5,}
            --,
            preselect = cmp.PreselectMode.None,
            confirm_opts = {
                behavior = cmp.ConfirmBehavior.Replace,
                select = true,
            },
            view = {
                docs = {
                    auto_open = false
                }
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<C-d>"] = cmp.mapping.scroll_docs(4),
                ["<C-u>"] = cmp.mapping.scroll_docs(-4),
                ['<C-g>'] = function()
                    if cmp.visible_docs() then
                        cmp.close_docs()
                    else
                        cmp.open_docs()
                    end
                end,
            }),
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'luasnip' }, -- For luasnip users.
                { name = 'buffer' },
            })
        })

        -- vim.diagnostic.config({
        --     -- update_in_insert = true,
        --     float = {
        --         focusable = true,
        --         style = "minimal",
        --         border = "rounded",
        --         source = "always",
        --         header = "",
        --         prefix = "",
        --     },
        -- })


        vim.diagnostic.config({
            signs = {
                text = {
                    [vim.diagnostic.severity.ERROR] = "󰅚",
                    [vim.diagnostic.severity.WARN] = "󰀪",
                    [vim.diagnostic.severity.HINT] = "󰌶",
                    [vim.diagnostic.severity.INFO] = "",
                }
            },
            float = {
                header = "",
                focusable = false,
                border = "rounded",
                close_events = {
                    "BufLeave",
                    "CursorMoved",
                    "InsertEnter",
                    "FocusLost"
                },
                prefix = "",
                suffix = "",
                format = function(diagnostic)
                    if diagnostic.source == 'rustc'
                        and diagnostic.user_data.lsp.data ~= nil
                    then
                        return diagnostic.user_data.lsp.data.rendered
                    else
                        return diagnostic.message
                    end
                end,
            },
            virtual_text = false,
            update_in_insert = true,
        })

        vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Show diagnostic" })
    end
}
