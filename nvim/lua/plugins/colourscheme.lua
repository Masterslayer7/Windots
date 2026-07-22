return {
    "folke/tokyonight.nvim",
    name = "tokyonight",
    lazy = false,
    priority = 1000,
    opts = {
        style = "night", -- storm, moon, night, day
        transparent = true,
        terminal_colors = true,
        styles = {
            comments = { italic = true },
            keywords = { italic = true },
            sidebars = "transparent",
            floats = "transparent",
        },
    },
}
