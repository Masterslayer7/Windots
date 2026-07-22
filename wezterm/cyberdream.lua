-- Noctis Default theme for WezTerm
return {
    foreground = "#b2cacd",
    background = "#03191b", -- Rich dark teal

    cursor_bg = "#b2cacd",
    cursor_fg = "#03191b",
    cursor_border = "#b2cacd",

    selection_fg = "#b2cacd",
    selection_bg = "#083d44", -- Dark teal selection

    scrollbar_thumb = "#052225",
    split = "#083d44", -- Clean split divider

    ansi = {
        "#324a4d", -- Black
        "#e66533", -- Red (Noctis Orange-Red)
        "#49e9a6", -- Green
        "#e4b781", -- Yellow
        "#49ace9", -- Blue
        "#df769b", -- Magenta
        "#49d6e9", -- Cyan
        "#b2cacd", -- White
    },
    brights = {
        "#47686c", -- Black
        "#e97749", -- Red
        "#60ebb1", -- Green
        "#e69533", -- Yellow
        "#60b6eb", -- Blue
        "#e798b3", -- Magenta
        "#60dbeb", -- Cyan
        "#c1d4d7", -- White
    },
    indexed = {
        [16] = "#e69533", -- Bright Yellow
        [17] = "#e97749", -- Bright Red
    },
}
