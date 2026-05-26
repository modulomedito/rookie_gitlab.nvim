# rookie_gitlab.nvim

## Installation

Use lazy.nvim to install this plugin.

```lua
require("lazy").setup({
    {
        "modulomedito/rookie_gitlab.nvim",
        config = function()
            require("rookie_gitlab").setup()
        end,
    },
})
```
