return {
    "scottmckendry/cyberdream.nvim",
    dev = true,
    lazy = false,
    priority = 1000,
    ---@type cyberdream.Config
    opts = {
        variant = "auto",
        transparent = true,
        italic_comments = true,
        hide_fillchars = true,
        terminal_colors = false,
        cache = true,
        borderless_pickers = true,
        colors = {
            bg = "#03191b",
            fg = "#b2cacd",
            grey = "#324a4d",
            blue = "#49ace9",
            green = "#49e9a6",
            cyan = "#49d6e9",
            red = "#e66533",
            yellow = "#e4b781",
            magenta = "#df769b",
            purple = "#df769b",
            orange = "#e69533",
        },
        overrides = function(c)
            return {
                CursorLine = { bg = c.bg },
                CursorLineNr = { fg = c.magenta },
            }
        end,
    },
}
