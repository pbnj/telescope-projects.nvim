# telescope-projects.nvim

A minimal [telescope](https://github.com/nvim-telescope/telescope.nvim)
extension for fuzzy searching and launching git projects from neovim.

## Install

Install using your favorite neovim plugin manager.

Example using [Lazy](https://github.com/folke/lazy.nvim):

```lua
require("lazy").setup({
    {
        "https://github.com/nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = {
            "https://github.com/pbnj/telescope-projects.nvim",
        },
        config = function()
            pcall(require("telescope").load_extension, "projects")
        end,
    }
})
```

## Usage

Command:

`:Telescope projects`

Lua API:

`require("telescope").extensions.projects.projects`

NeoVim keymapping:

```lua
vim.keymap.set( "n", "<leader>uu", require("telescope").extensions.projects.projects, { noremap = true, desc = "Telescope: Projects" })
```

## Related Projects

For a more robust Telescope extension, see [telescope-project.nvim](https://github.com/nvim-telescope/telescope-project.nvim).

## License

MIT
