local M = {}

local ns = vim.api.nvim_create_namespace("rookie_gitlab.highlights")
local did_setup = false

local function issue_state_group(state)
    if state == "opened" then
        return "RkGitlabIssueStateOpened"
    end

    if state == "closed" then
        return "RkGitlabIssueStateClosed"
    end

    return "RkGitlabIssueState"
end

local function add_highlight(buf, line_idx, group, start_col, end_col)
    if start_col < 0 or end_col <= start_col then
        return
    end

    vim.api.nvim_buf_add_highlight(buf, ns, group, line_idx, start_col, end_col)
end

local function highlight_header(buf, line_idx, line)
    if line:match("^=== .+ ===$") then
        add_highlight(buf, line_idx, "RkGitlabHeader", 0, #line)
        return true
    end

    return false
end

local function highlight_filter_line(buf, line_idx, line)
    local _, label_end = line:find(": ", 1, true)
    if not label_end then
        return false
    end

    local label = line:sub(1, label_end)
    if label ~= "Filter: " and label ~= "Quick Filter: " then
        return false
    end

    add_highlight(buf, line_idx, "RkGitlabLabel", 0, label_end)
    if label_end < #line then
        add_highlight(buf, line_idx, "RkGitlabFilterValue", label_end, #line)
    end

    return true
end

local function highlight_project_line(buf, line_idx, line)
    local id_start, id_end = line:find("^%[%d+%]")
    if not id_start then
        return false
    end

    add_highlight(buf, line_idx, "RkGitlabProjectId", id_start - 1, id_end)

    if id_end + 1 < #line then
        add_highlight(buf, line_idx, "RkGitlabProjectName", id_end + 1, #line)
    end

    return true
end

local function highlight_issue_line(buf, line_idx, line)
    local iid_start, iid_end = line:find("^#%d+")
    local meta_start, meta_end = line:find("%[[^%]]+%]")
    if not iid_start or not meta_start or not meta_end then
        return false
    end

    add_highlight(buf, line_idx, "RkGitlabIssueId", iid_start - 1, iid_end)
    add_highlight(buf, line_idx, "RkGitlabDelimiter", meta_start - 1, meta_start)
    add_highlight(buf, line_idx, "RkGitlabDelimiter", meta_end - 1, meta_end)

    local meta = line:sub(meta_start + 1, meta_end - 1)
    local at_pos = meta:find("@", 1, true)
    if at_pos then
        local state = meta:sub(1, at_pos - 1)
        local state_start = meta_start + 1
        local state_end = meta_start + at_pos - 1
        local at_col = meta_start + at_pos
        local assignee_start = meta_start + at_pos + 1
        local assignee_end = meta_end - 1

        add_highlight(buf, line_idx, issue_state_group(state), state_start - 1, state_end)
        add_highlight(buf, line_idx, "RkGitlabDelimiter", at_col - 1, at_col)
        if assignee_start <= assignee_end then
            add_highlight(buf, line_idx, "RkGitlabAssignee", assignee_start - 1, assignee_end)
        end
    else
        add_highlight(buf, line_idx, "RkGitlabIssueState", meta_start, meta_end - 1)
    end

    if meta_end + 1 < #line then
        add_highlight(buf, line_idx, "RkGitlabIssueTitle", meta_end + 1, #line)
    end

    return true
end

local function apply_projects(buf, lines)
    for idx, line in ipairs(lines) do
        local line_idx = idx - 1
        if not highlight_header(buf, line_idx, line) then
            if not highlight_filter_line(buf, line_idx, line) then
                highlight_project_line(buf, line_idx, line)
            end
        end
    end
end

local function apply_issues(buf, lines)
    for idx, line in ipairs(lines) do
        local line_idx = idx - 1
        if not highlight_header(buf, line_idx, line) then
            if not highlight_filter_line(buf, line_idx, line) then
                highlight_issue_line(buf, line_idx, line)
            end
        end
    end
end

function M.setup()
    if did_setup then
        return
    end

    did_setup = true

    vim.api.nvim_set_hl(0, "RkGitlabHeader", { default = true, link = "Title" })
    vim.api.nvim_set_hl(0, "RkGitlabLabel", { default = true, link = "PreProc" })
    vim.api.nvim_set_hl(0, "RkGitlabFilterValue", { default = true, link = "String" })
    vim.api.nvim_set_hl(0, "RkGitlabProjectId", { default = true, link = "Number" })
    vim.api.nvim_set_hl(0, "RkGitlabProjectName", { default = true, link = "Directory" })
    vim.api.nvim_set_hl(0, "RkGitlabIssueId", { default = true, link = "Number" })
    vim.api.nvim_set_hl(0, "RkGitlabIssueState", { default = true, link = "Keyword" })
    vim.api.nvim_set_hl(0, "RkGitlabIssueStateOpened", { default = true, fg = "#f7768e", bold = true })
    vim.api.nvim_set_hl(0, "RkGitlabIssueStateClosed", { default = true, fg = "#9ece6a", bold = true })
    vim.api.nvim_set_hl(0, "RkGitlabAssignee", { default = true, link = "Identifier" })
    vim.api.nvim_set_hl(0, "RkGitlabIssueTitle", { default = true, link = "Normal" })
    vim.api.nvim_set_hl(0, "RkGitlabDelimiter", { default = true, link = "Delimiter" })
end

function M.clear(buf)
    if buf and vim.api.nvim_buf_is_valid(buf) then
        vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
    end
end

function M.apply(buf, view)
    if not buf or not vim.api.nvim_buf_is_valid(buf) then
        return
    end

    M.setup()
    M.clear(buf)

    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    if view == "projects" then
        apply_projects(buf, lines)
    elseif view == "issues" then
        apply_issues(buf, lines)
    end
end

return M
