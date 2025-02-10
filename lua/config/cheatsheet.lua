local M = {}

local keybindings = {
    ["Telescope"] = {
        ["<leader>ff"] = "Find files",
        ["<leader>fg"] = "Live grep",
        ["<leader>fb"] = "Browse buffers",
        ["<leader>fh"] = "Help tags",
    },
    ["mini.surround"] = {
        ["sa{motion}"] = "Add surrounding (e.g., saiw( to surround word with parentheses)",
        ["sd"] = "Delete surrounding",
        ["sr"] = "Replace surrounding",
        ["sf"] = "Find surrounding forward",
        ["sF"] = "Find surrounding backward",
    },
    ["mini.comment"] = {
        ["gcc"] = "Toggle comment for current line",
        ["gc{motion}"] = "Toggle comment for motion (e.g., gcap for paragraph)",
        ["gc"] = "Toggle comment (visual mode)",
    },
    ["mini.ai text objects"] = {
        ["a)"] = "Around parentheses (also b)",
        ["i)"] = "Inside parentheses (also b)",
        ["a]"] = "Around brackets",
        ["i]"] = "Inside brackets",
        ["a}"] = "Around braces (also B)",
        ["i}"] = "Inside braces (also B)",
        ["af"] = "Around function call",
        ["if"] = "Inside function call",
        ["a\""] = "Around quotes",
        ["i\""] = "Inside quotes",
    },
    ["LSP"] = {
        ["gD"] = "Go to declaration",
        ["gd"] = "Go to definition",
        ["K"] = "Hover documentation",
        ["gi"] = "Go to implementation",
        ["<C-k>"] = "Signature help",
        ["<leader>rn"] = "Rename symbol",
        ["<leader>ca"] = "Code action",
        ["gr"] = "Find references",
    },
    ["Examples"] = {
        ["saiw("] = "Surround word with parentheses",
        ["sa2j}"] = "Surround 2 lines down with braces",
        ["sdf"] = "Delete surrounding function call",
        ["srb]"] = "Replace surrounding parentheses with brackets",
        ["gcaf"] = "Comment entire function",
        ["ci\""] = "Change inside quotes",
        ["daf"] = "Delete around function",
    }
}

function M.show_keybindings()
    local buf = vim.api.nvim_create_buf(false, true)
    
    vim.api.nvim_buf_set_option(buf, 'modifiable', true)
    vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')
    vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
    
    local lines = {"# Neovim Keybindings Quick Reference", ""}
    
    for plugin, bindings in pairs(keybindings) do
        table.insert(lines, "## " .. plugin)
        table.insert(lines, "")
        for key, description in pairs(bindings) do
            table.insert(lines, string.format("%-20s %s", key, description))
        end
        table.insert(lines, "")
    end
    
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    
    local width = vim.api.nvim_get_option("columns")
    local height = vim.api.nvim_get_option("lines")
    local win_height = math.ceil(height * 0.8 - 4)
    local win_width = math.ceil(width * 0.8)
    local row = math.ceil((height - win_height) / 2 - 1)
    local col = math.ceil((width - win_width) / 2)
    
    local opts = {
        style = "minimal",
        relative = "editor",
        width = win_width,
        height = win_height,
        row = row,
        col = col,
        border = "rounded"
    }
    local win = vim.api.nvim_open_win(buf, true, opts)
    vim.api.nvim_win_set_option(win, 'wrap', false)
    vim.api.nvim_win_set_option(win, 'cursorline', true)
    vim.api.nvim_buf_set_option(buf, 'modifiable', false)
    vim.api.nvim_buf_set_keymap(buf, 'n', 'q', ':close<CR>', {noremap = true, silent = true})
    vim.api.nvim_buf_set_keymap(buf, 'n', '<Esc>', ':close<CR>', {noremap = true, silent = true})
end

vim.api.nvim_set_keymap('n', '<leader>?', 
    [[<cmd>lua require('config.cheatsheet').show_keybindings()<CR>]], 
    {noremap = true, silent = true})

return M
