-- Tundra Forest: A snowy day in a tundra forest theme
return {
    foreground = "#e6edf0",
    background = "#0a110f",

    cursor_bg = "#e6edf0",
    cursor_fg = "#0a110f",
    cursor_border = "#e6edf0",

    selection_fg = "#ffffff",
    selection_bg = "#233932", -- Frosted pine-slate selection

    scrollbar_thumb = "#131f1c",
    split = "#1c2e29", -- Subtle dark pine pane borders

    -- Normal ANSI colors (spruce green, ice blue, frost white, winter sun)
    ansi = {
        "#0a110f", -- Black
        "#d96a7d", -- Red (Berry)
        "#7cb89f", -- Green (Spruce)
        "#d9c285", -- Yellow (Sunlight)
        "#85a9bf", -- Blue (Glacier)
        "#a397be", -- Magenta (Dusk)
        "#86c5da", -- Cyan (Ice)
        "#e6edf0", -- White (Snow)
    },
    -- Bright ANSI colors
    brights = {
        "#233932", -- Black
        "#e67d8f", -- Red
        "#99d6bb", -- Green
        "#ecdca5", -- Yellow
        "#a5cce3", -- Blue
        "#c0b3db", -- Magenta
        "#a2d2df", -- Cyan
        "#ffffff", -- White
    },
    indexed = {
        [16] = "#d9a473", -- Soft Orange
        [17] = "#e67d8f", -- Bright Berry Red
    },
}
