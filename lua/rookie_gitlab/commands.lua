local M = {}

function M.setup()
    vim.api.nvim_create_user_command("RkGitlabIssue", function(opts)
        local core = require("rookie_gitlab")
        local args = opts.fargs
        if #args == 0 then
            core.open()
        else
            local action = args[1]
            if action == "close" then
                core.close_issue()
            elseif action == "open" then
                core.open_issue()
            elseif action == "comment" then
                core.comment_issue()
            elseif action == "add" then
                core.add_issue()
            elseif action == "edit" then
                core.edit_issue()
            elseif action == "toggle" then
                core.toggle()
            else
                vim.notify(
                    "[RkGitlab] Unknown action: " .. action,
                    vim.log.levels.ERROR
                )
            end
        end
    end, {
        nargs = "*",
        desc = "Open GitLab Projects and Issues Browser or perform actions",
        complete = function()
            return { "open", "close", "comment", "add", "edit", "toggle" }
        end,
    })
end

return M
