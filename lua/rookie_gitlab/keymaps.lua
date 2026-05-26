local M = {}

function M.setup()
    vim.keymap.set("n", "<leader>gl", "<cmd>RkGitlabIssue toggle<CR>", {
        silent = true,
    })
end

function M.setup_ui_buffer(buf)
    local opts = { noremap = true, silent = true }
    vim.api.nvim_buf_set_keymap(buf, "n", "q", "<cmd>lua require('rookie_gitlab').close()<CR>", opts)
    vim.api.nvim_buf_set_keymap(buf, "n", "<CR>", "<cmd>lua require('rookie_gitlab').on_enter()<CR>", opts)
    vim.api.nvim_buf_set_keymap(buf, "n", "r", "<cmd>lua require('rookie_gitlab').refresh()<CR>", opts)
    vim.api.nvim_buf_set_keymap(buf, "n", "/", "<cmd>lua require('rookie_gitlab').search()<CR>", opts)
    vim.api.nvim_buf_set_keymap(buf, "n", "M", "<cmd>lua require('rookie_gitlab').toggle_quick_filter()<CR>", opts)
    vim.api.nvim_buf_set_keymap(buf, "n", "<BS>", "<cmd>lua require('rookie_gitlab').go_back()<CR>", opts)
    vim.api.nvim_buf_set_keymap(buf, "n", "<C-o>", "<cmd>lua require('rookie_gitlab').go_back()<CR>", opts)
    vim.api.nvim_buf_set_keymap(buf, "n", "<C-i>", "<cmd>lua require('rookie_gitlab').go_forward()<CR>", opts)
    vim.api.nvim_buf_set_keymap(buf, "n", "g?", "<cmd>lua require('rookie_gitlab').toggle_help()<CR>", opts)
end

function M.setup_issue_edit(ctx)
    local opts = { noremap = true, silent = true }

    -- title buffer
    vim.api.nvim_buf_set_keymap(ctx.buf_title, "n", "<C-w>j", string.format("<cmd>lua vim.api.nvim_set_current_win(%d)<CR>", ctx.win_desc), opts)
    vim.api.nvim_buf_set_keymap(ctx.buf_title, "n", "<C-w>k", string.format("<cmd>lua vim.api.nvim_set_current_win(%d)<CR>", ctx.win_flags), opts)
    vim.api.nvim_buf_set_keymap(ctx.buf_title, "n", "<C-j>", string.format("<cmd>lua vim.api.nvim_set_current_win(%d)<CR>", ctx.win_desc), opts)
    vim.api.nvim_buf_set_keymap(ctx.buf_title, "n", "<C-k>", string.format("<cmd>lua vim.api.nvim_set_current_win(%d)<CR>", ctx.win_flags), opts)

    -- desc buffer
    vim.api.nvim_buf_set_keymap(ctx.buf_desc, "n", "<C-w>j", string.format("<cmd>lua vim.api.nvim_set_current_win(%d)<CR>", ctx.win_flags), opts)
    vim.api.nvim_buf_set_keymap(ctx.buf_desc, "n", "<C-w>k", string.format("<cmd>lua vim.api.nvim_set_current_win(%d)<CR>", ctx.win_title), opts)
    vim.api.nvim_buf_set_keymap(ctx.buf_desc, "n", "<C-j>", string.format("<cmd>lua vim.api.nvim_set_current_win(%d)<CR>", ctx.win_flags), opts)
    vim.api.nvim_buf_set_keymap(ctx.buf_desc, "n", "<C-k>", string.format("<cmd>lua vim.api.nvim_set_current_win(%d)<CR>", ctx.win_title), opts)

    -- flags buffer
    vim.api.nvim_buf_set_keymap(ctx.buf_flags, "n", "<C-w>j", string.format("<cmd>lua vim.api.nvim_set_current_win(%d)<CR>", ctx.win_confirm), opts)
    vim.api.nvim_buf_set_keymap(ctx.buf_flags, "n", "<C-w>k", string.format("<cmd>lua vim.api.nvim_set_current_win(%d)<CR>", ctx.win_desc), opts)
    vim.api.nvim_buf_set_keymap(ctx.buf_flags, "n", "<C-j>", string.format("<cmd>lua vim.api.nvim_set_current_win(%d)<CR>", ctx.win_confirm), opts)
    vim.api.nvim_buf_set_keymap(ctx.buf_flags, "n", "<C-k>", string.format("<cmd>lua vim.api.nvim_set_current_win(%d)<CR>", ctx.win_desc), opts)

    -- confirm buffer
    vim.api.nvim_buf_set_keymap(ctx.buf_confirm, "n", "<C-w>k", string.format("<cmd>lua vim.api.nvim_set_current_win(%d)<CR>", ctx.win_flags), opts)
    vim.api.nvim_buf_set_keymap(ctx.buf_confirm, "n", "<C-k>", string.format("<cmd>lua vim.api.nvim_set_current_win(%d)<CR>", ctx.win_flags), opts)
    vim.api.nvim_buf_set_keymap(ctx.buf_confirm, "n", "<C-w>j", string.format("<cmd>lua vim.api.nvim_set_current_win(%d)<CR>", ctx.win_title), opts)
    vim.api.nvim_buf_set_keymap(ctx.buf_confirm, "n", "<C-j>", string.format("<cmd>lua vim.api.nvim_set_current_win(%d)<CR>", ctx.win_title), opts)
    vim.api.nvim_buf_set_keymap(ctx.buf_confirm, "n", "<C-w>l", string.format("<cmd>lua vim.api.nvim_set_current_win(%d)<CR>", ctx.win_cancel), opts)
    vim.api.nvim_buf_set_keymap(ctx.buf_confirm, "n", "<C-l>", string.format("<cmd>lua vim.api.nvim_set_current_win(%d)<CR>", ctx.win_cancel), opts)

    -- cancel buffer
    vim.api.nvim_buf_set_keymap(ctx.buf_cancel, "n", "<C-w>k", string.format("<cmd>lua vim.api.nvim_set_current_win(%d)<CR>", ctx.win_flags), opts)
    vim.api.nvim_buf_set_keymap(ctx.buf_cancel, "n", "<C-k>", string.format("<cmd>lua vim.api.nvim_set_current_win(%d)<CR>", ctx.win_flags), opts)
    vim.api.nvim_buf_set_keymap(ctx.buf_cancel, "n", "<C-w>j", string.format("<cmd>lua vim.api.nvim_set_current_win(%d)<CR>", ctx.win_title), opts)
    vim.api.nvim_buf_set_keymap(ctx.buf_cancel, "n", "<C-j>", string.format("<cmd>lua vim.api.nvim_set_current_win(%d)<CR>", ctx.win_title), opts)
    vim.api.nvim_buf_set_keymap(ctx.buf_cancel, "n", "<C-w>h", string.format("<cmd>lua vim.api.nvim_set_current_win(%d)<CR>", ctx.win_confirm), opts)
    vim.api.nvim_buf_set_keymap(ctx.buf_cancel, "n", "<C-h>", string.format("<cmd>lua vim.api.nvim_set_current_win(%d)<CR>", ctx.win_confirm), opts)

    vim.api.nvim_buf_set_keymap(ctx.buf_confirm, "n", "<CR>", "", {
        noremap = true,
        silent = true,
        callback = function()
            ctx.save_action()
            vim.schedule(ctx.close_action)
        end,
    })

    vim.api.nvim_buf_set_keymap(ctx.buf_cancel, "n", "<CR>", "", {
        noremap = true,
        silent = true,
        callback = function()
            ctx.cancel_action()
            vim.schedule(ctx.close_action)
        end,
    })
end

return M
