# rookie_gitlab.nvim

## Installation

Use lazy.nvim to install this plugin.

```lua
require("lazy").setup({
    {
        "modulomedito/rookie_gitlab.nvim",
        config = function()
            vim.g.gitlab_url = "https://gitlab.com"
            vim.g.gitlab_token = "your_token"
            require("rookie_gitlab").setup()
        end,
    },
})
```
