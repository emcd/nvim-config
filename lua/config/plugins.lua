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

    -- Note: Broken with Python syntax on WSL/wsltty.
    -- {
    --     'ishan9299/nvim-solarized-lua',
    --     -- lazy = false,  -- load during startup
    --     -- priority = 1000,  -- load first to prevent flashing
    --     config = function()
    --         vim.g.solarized_italics = 0
    --         vim.opt.background = 'dark'
    --         vim.cmd([[colorscheme solarized]])
    --     end,
    -- },

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

    {
        'mfussenegger/nvim-lint',
        config = function()
            require('lint').linters_by_ft = {
                python = {'bandit', 'ruff'},
            }
            vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
                callback = function()
                  require('lint').try_lint()  -- linters_by_ft
                  -- require('lint').try_lint('cspell')
                end,
            })
        end
    },

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
                        {
                            function()
                                local parsers = require('nvim-treesitter.parsers')
                                if not parsers.has_parser() then
                                    return '(nil)'
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
            -- require('mini.ai').setup({})
            require('mini.comment').setup({})
            -- require('mini.pairs').setup({})
            require('mini.surround').setup({
                mappings = {
                    add = 'Sa',            -- Add surrounding
                    delete = 'Sd',         -- Delete surrounding
                    find = 'Sf',           -- Find surrounding
                    find_left = 'SF',      -- Find surrounding to the left
                    highlight = 'Sh',      -- Highlight surrounding
                    replace = 'Sr',        -- Replace surrounding
                    update_n_lines = 'Sn', -- Update `n_lines`
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

}
