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
            fg = "#ffffff",
            grey = "#3c4048",
            blue = "#b3d3e3",
            green = "#8fe4c1",
            cyan = "#bce6f2",
            red = "#e68595",
            yellow = "#ebd69b",
            magenta = "#b8add1",
            purple = "#b8add1",
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
