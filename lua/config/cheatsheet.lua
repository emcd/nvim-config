local M = {}

local keybindings = {

    ["Builtin: Miscellaneous"] = {
        ["g&"] = "Repeat last substitution on all lines",
        ["g8"] = "Print hex value of bytes in UTF-8 character under cursor",
        ["ge"] = "Go backwards to end of previous word",
        ["gf"] = "Start editing file whose name is under cursor",
        ["gq{motion}"] = "format text selected by motion",
        ["z."] = "Redraw, cursor line at center of window, on first non-blank",
        ["z="] = "Give spelling suggestions",
        ["zH"] = "Scroll half screenwidth right (nowrap)",
        ["zL"] = "Scroll half screenwidth left (nowrap)",
    },

    ["Builtin: Quickfix"] = {
        [":copen"] = "Open quickfix window",
        [":cclose"] = "Close quickfix window",
        [":cn[ext]"] = "Next quickfix item",
        [":cp[rev]"] = "Previous quickfix item",
        [":cc N"] = "Jump to Nth quickfix item",
        [":cdo {cmd}"] = "Execute command on each quickfix entry",
        ["<C-W> Enter"] = "Open item in new split (from quickfix window)",
    },

    ["mini.comment"] = {
        ["gcc"] = "Toggle comment for current line",
        ["gc{motion}"] = "Toggle comment for motion (e.g., gcip for paragraph)",
        ["V{selection} gc"] = "Toggle comment",
    },

    ["mini.surround"] = {
        ["sa{motion}"] = "Add surrounding (e.g., Saiw( to surround word with parentheses)",
        ["sd"] = "Delete surrounding",
        ["sc"] = "Replace surrounding",
        ["sf"] = "Find surrounding forward",
        ["sF"] = "Find surrounding backward",
    },

    ["telescope"] = {
        ["<leader>fb"] = "Browse buffers",
        ["<leader>ff"] = "Find files",
        ["<leader>fg"] = "Live grep",
        ["<leader>fh"] = "Help tags",
    },

    ["LSP"] = {
        ["<C-k>"] = "Signature help",
        ["K"] = "Hover documentation",
        ["gD"] = "Go to declaration",
        ["gd"] = "Go to definition",
        ["gi"] = "Go to implementation",
        ["<leader>ca"] = "Code action",
        ["<leader>fr"] = "Find references",
        ["<leader>rn"] = "Rename symbol",
    },

    -- ["text objects"] = {
    --     ["a)"] = "Around parentheses (also b)",
    --     ["i)"] = "Inside parentheses (also b)",
    --     ["a]"] = "Around brackets",
    --     ["i]"] = "Inside brackets",
    --     ["a}"] = "Around braces (also B)",
    --     ["i}"] = "Inside braces (also B)",
    --     ["af"] = "Around function call",
    --     ["if"] = "Inside function call",
    --     ["a\""] = "Around quotes",
    --     ["i\""] = "Inside quotes",
    -- },

    ["Vim Regex Magic Levels"] = {
        ["\\v"] = "Very magic: Most special chars don't need escaping ()|?+*",
        ["\\m"] = "Magic (default): Some chars need escaping like () and |",
        ["\\M"] = "Nomagic: Most chars are literal except ^ and $",
        ["\\V"] = "Very nomagic: All chars literal except \\",
    },

    ["Examples"] = {
        ["saiw("] = "Surround word with parentheses",
        ["sdf"] = "Delete surrounding function call",
        ["srb]"] = "Replace surrounding parentheses with brackets",
        ["gcaf"] = "Comment entire function",
        ["ci\""] = "Change inside quotes",
        ["daf"] = "Delete around function",
        ["%s/\\v\"\"\"(\\S.*\\S)\"\"\"/''' \\1 '''/g"] = "Replace triple quotes and add internal padding",
    }

}

function M.show_keybindings()
    local buf = vim.api.nvim_create_buf(false, true)
    
    vim.api.nvim_buf_set_option(buf, 'modifiable', true)
    vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')
    vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
    
    local lines = {"# Neovim Quick Reference", ""}
    
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
