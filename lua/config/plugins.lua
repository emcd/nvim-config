return {

    {
        'catppuccin/nvim',
        name = 'catppuccin',
        -- lazy = false,
        priority = 1000,
        config = function()
            require('catppuccin').setup({
                custom_highlights = function(C)
                    -- Match mode colors from lualine theme.
                    return {
                        CursorNormal = { bg = C.blue },
                        CursorInsert = { bg = C.green },
                        CursorVisual = { bg = C.mauve },
                        CursorReplace = { bg = C.red },
                        CursorCommand = { bg = C.peach },
                    }
                end,
                styles = {
                    comments = {},
                    conditionals = {},
                    miscs = {},
                },
            })

            -- TODO: Fix.
            -- vim.api.nvim_create_autocmd("ModeChanged", {
            --     callback = function()
            --         local mode = vim.api.nvim_get_mode().mode
            --         local cursor_color = {
            --             n = "CursorNormal",
            --             i = "CursorInsert",
            --             v = "CursorVisual",
            --             V = "CursorVisual",
            --             [""] = "CursorVisual",
            --             R = "CursorReplace",
            --             c = "CursorCommand",
            --         }
            --         vim.api.nvim_set_hl(0, "Cursor", { link = cursor_color[mode] or "CursorNormal" })
            --     end,
            -- })

            vim.cmd.colorscheme 'catppuccin-macchiato'
        end
    },

    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        config = function()
            require('nvim-treesitter.configs').setup({
                ensure_installed = {
                    'html',
                    'json',
                    'lua',
                    'markdown',
                    'python',
                    'rst',
                    'rust',
                    'toml',
                    'vim',
                    'yaml',
                },
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
                indent = {
                    enable = true,
                    disable = { 'python' },
                },
            })
        end
    },

    {
        'neovim/nvim-lspconfig',
        config = function()
            require('config.lsp')
        end
    },

    -- {
    --     'mfussenegger/nvim-lint',
    --     config = function()
    --         require('lint').linters_by_ft = {
    --             python = {'bandit', 'ruff'},
    --         }
    --         vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
    --             callback = function()
    --               require('lint').try_lint()  -- linters_by_ft
    --               -- require('lint').try_lint('cspell')
    --             end,
    --         })
    --     end
    -- },

    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            require('lualine').setup({
                options = {
                    component_separators = { left = '|', right = '|'},
                    section_separators = { left = '', right = ''},
                    theme = 'catppuccin-macchiato',
                },
                sections = {
                    lualine_a = {'mode'},
                    lualine_b = {'branch'},
                    lualine_c = { 'filename', },
                    lualine_x = {'encoding', 'filetype'}, -- {'fileformat'}
                    lualine_y = {
                        -- {
                        --     function()
                        --         local parsers = require('nvim-treesitter.parsers')
                        --         if not parsers.has_parser() then
                        --             return '(nil)'
                        --         end
                        --         local lang = parsers.get_parser():lang()
                        --         return 'TS: ' .. lang
                        --     end,
                        -- },
                        {
                            function()
                                local bufnr   = vim.api.nvim_get_current_buf()
                                -- Works on NVIM ≥0.12; falls back gracefully on older builds
                                local get     = vim.lsp.get_clients or vim.lsp.get_active_clients
                                local clients = get({ bufnr = bufnr }) or get()
                                if #clients == 0 then
                                  return '(nil)'
                                end
                                local names = {}
                                for _, client in ipairs(clients) do
                                  table.insert(names, client.name)
                                end
                                return table.concat(names, ', ')
                            end,
                            icon = 'LSP:',
                            -- color = { fg = '#ffffff', gui = 'bold' },
                        },
                    },
                    lualine_z = {'location'}
                },
            })
        end,
    },

    {
        'echasnovski/mini.nvim',
        version = false,    -- Use latest version
        config = function()
            -- require('mini.ai').setup({})
            require('mini.comment').setup({})
            -- require('mini.pairs').setup({})
            require('mini.surround').setup({
                mappings = {
                    add = 'sa',            -- Add surrounding
                    delete = 'sd',         -- Delete surrounding
                    find = 'sf',           -- Find surrounding
                    find_left = 'sF',      -- Find surrounding to the left
                    highlight = 'sh',      -- Highlight surrounding
                    replace = 'sc',        -- Replace surrounding
                    update_n_lines = 'sn', -- Update `n_lines`
                },
            })
        end,
    },

    {
        'nvim-telescope/telescope.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            local telescope = require('telescope')
            telescope.setup({})
            local builtin = require('telescope.builtin')
            vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
            vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
            vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
            vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
        end,
    },

    -- {
    --     -- Binary manager (installs rust-analyzer, codelldb, etc.)
    --     'williamboman/mason.nvim',
    --     dependencies = { 'williamboman/mason-lspconfig.nvim' },
    --     config = function()
    --       require('mason').setup()
    --       require('mason-lspconfig').setup({
    --           -- ensure_installed = { 'rust_analyzer' },
    --       })
    --     end,
    -- },

    -- Rust helper (plugin only – actual logic sits in lsp.lua)
    {
        'mrcjkb/rustaceanvim',
        version = '*',
        ft = { 'rust' },               -- lazy-load on Rust buffers
        -- no init(), no config() here
    },

}
