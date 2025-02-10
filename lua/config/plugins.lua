return {
    {
        'ishan9299/nvim-solarized-lua',
        lazy = false,  -- load during startup
        priority = 1000,  -- load first to prevent flashing
        config = function()
            vim.g.solarized_italics = 0
            vim.opt.background = 'dark'
            vim.cmd([[colorscheme solarized]])
        end,
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
                highlight = { enable = true },
            })
        end
    },
    {
        'neovim/nvim-lspconfig',
        config = function()
            require('config.lsp')
        end
    },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            require('lualine').setup({
                options = {
                    theme = 'solarized_dark',
                    component_separators = { left = '|', right = '|'},
                    section_separators = { left = '', right = ''},
                },
                sections = {
                    lualine_a = {'mode'},
                    lualine_b = {'branch'},
                    lualine_c = { 'filename', },
                    lualine_x = {'encoding', 'filetype'}, -- {'fileformat'}
                    lualine_y = {
                        {
                            function()
                                local parsers = require('nvim-treesitter.parsers')
                                if not parsers.has_parser() then
                                    return 'No TS'
                                end
                                local lang = parsers.get_parser():lang()
                                return 'TS: ' .. lang
                            end,
                        },
                        {
                            function()
                                local msg = '(nil)'
                                local buf_clients = vim.lsp.get_active_clients()
                                if next(buf_clients) == nil then
                                    return msg
                                end
                                local buf_client_names = {}
                                for _, client in pairs(buf_clients) do
                                    if client.attached_buffers[vim.api.nvim_get_current_buf()] then
                                        table.insert(buf_client_names, client.name)
                                    end
                                end
                                return table.concat(buf_client_names, ', ')
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
            require('mini.ai').setup({})
            require('mini.comment').setup({})
            -- require('mini.pairs').setup({})
            require('mini.surround').setup({
                -- Customize mappings if desired (these are the defaults)
                mappings = {
                    add = 'sa',             -- Add surrounding
                    delete = 'sd',          -- Delete surrounding
                    find = 'sf',            -- Find surrounding
                    find_left = 'sF',       -- Find surrounding to the left
                    highlight = 'sh',       -- Highlight surrounding
                    replace = 'sr',         -- Replace surrounding
                    update_n_lines = 'sn',  -- Update `n_lines`
                },
            })
        end,
    },
    {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            local telescope = require('telescope')
            telescope.setup({})
            local builtin = require('telescope.builtin')
            vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
            vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
            vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
            vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
        end,
    },
}
