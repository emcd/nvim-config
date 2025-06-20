local lspconfig = require('lspconfig')

local on_attach = function(client, bufnr)
    local opts = { noremap=true, silent=true, buffer=bufnr }
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', '<leader>fr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
end

vim.diagnostic.config({
    severity_sort = true,
    signs = true,
    underline = false,
    update_in_insert = false,
    virtual_text = false,
    float = {
        source = 'always',
    },
})

-- vim.g.rustaceanvim = {
--     tools = {
--         float_win_config = { border = 'rounded' },
--     },
--     server = {
--         on_attach = on_attach,
--         default_settings = {
--             ['rust-analyzer'] = {
--                 cargo = { allFeatures = true },
--                 checkOnSave = { command = 'clippy' },
--                 procMacro = { enable = true },
--             },
--         },
--     },
-- }
vim.g.rustaceanvim = {
    server = {
        on_attach = on_attach,
        default_settings = {
            ['rust-analyzer'] = {
                cargo = { allFeatures = true },

                check = {
                    command = 'clippy',       -- or 'check' / 'nextest' / etc.
                    allTargets = true,        -- optional extras
                    -- extraArgs = { '--workspace' },
                },
                -- checkOnSave = true,

                procMacro = { enable = true },
                diagnostics = { experimental = { enable = true } },
            },
        },
    },
}


local client_capabilities = {
    -- https://github.com/microsoft/pyright/issues/4652#issuecomment-1439119295
    -- https://github.com/astral-sh/ruff-lsp/issues/384#issuecomment-1992012227
    -- https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#diagnosticTag
    textDocument = {
        publishDiagnostics = {
            tagSupport = {
                valueSet = { 2 },
            },
        },
    },
    -- -- https://github.com/microsoft/pyright/issues/4635#issuecomment-1430177826
    -- workspace = {
    --     didChangeWatchedFiles = {
    --         dynamicRegistration = true,
    --     }
    -- },
}

lspconfig.pyright.setup({
    capabilities = client_capabilities,
    on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
        on_attach(client, bufnr)
    end,
    settings = {
        pyright = {
            disableOrganizeImports = true,
            -- disableTaggedHints = true,
        },
        python = {
            analysis = {
                autoSearchPaths = true,
                diagnosticMode = 'workspace',
                useLibraryCodeForTypes = true,
            },
        },
    },
})

lspconfig.ruff.setup({
    capabilities = client_capabilities,
    on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = false
        -- Ruff range format of docstrings is annoying.
        client.server_capabilities.documentRangeFormattingProvider = false
        vim.bo[bufnr].formatexpr = ""
        -- Pyright hover is more detailed.
        client.server_capabilities.hoverProvider = false
        on_attach(client, bufnr)
        -- local opts = { noremap=true, silent=true, buffer=bufnr }
        -- vim.keymap.set(
        --     'n', '<leader>rf',
        --     function()
        --         vim.lsp.buf.code_action(
        --             { context = { only = { "source.fixAll.ruff" } }, apply = true }
        --         )
        --     end, opts)
    end,
})

-- lspconfig.rust_analyzer.setup({
--     on_attach = on_attach,
-- })
