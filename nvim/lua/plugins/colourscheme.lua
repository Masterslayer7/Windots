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
            bg = "#0a110f",
            fg = "#e6edf0",
            grey = "#3c4048",
            blue = "#85a9bf",
            green = "#7cb89f",
            cyan = "#86c5da",
            red = "#d96a7d",
            yellow = "#d9c285",
            magenta = "#a397be",
            purple = "#a397be",
            orange = "#d9a473",
        },
        overrides = function(c)
            return {
                CursorLine = { bg = c.bg },
                CursorLineNr = { fg = c.magenta },
            }
        end,
    },
}
