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

lspconfig.pyright.setup({
    -- https://github.com/microsoft/pyright/issues/4652#issuecomment-1439119295
    -- https://github.com/astral-sh/ruff-lsp/issues/384#issuecomment-1992012227
    -- https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#diagnosticTag
    capabilities = {
        textDocument = {
            publishDiagnostics = {
                tagSupport = {
                    valueSet = { 2 },
                },
            },
        },
    },
    on_attach = on_attach,
    settings = {
        -- pyright = { disableTaggedHints = true },
        python = {
            analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = 'workspace',
            },
        },
    },
})

lspconfig.rust_analyzer.setup({
    on_attach = on_attach,
})
