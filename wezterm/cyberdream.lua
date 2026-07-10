-- Tundra Forest: High contrast snowy tundra forest theme
return {
    foreground = "#ffffff",
    background = "#0a110f",

    cursor_bg = "#ffffff",
    cursor_fg = "#0a110f",
    cursor_border = "#ffffff",

    selection_fg = "#ffffff",
    selection_bg = "#233932",

    scrollbar_thumb = "#131f1c",
    split = "#1c2e29",

    -- Normal ANSI colors (spruce green, ice-white blue, snow white)
    ansi = {
        "#0a110f", -- Black
        "#e68595", -- Red (Berry)
        "#8fe4c1", -- Green (Frosted Spruce - Brighter)
        "#ebd69b", -- Yellow (Winter Sun - Brighter)
        "#b3d3e3", -- Blue (Glacier Ice-White - Brighter)
        "#b8add1", -- Magenta (Dusk - Brighter)
        "#bce6f2", -- Cyan (glacial Ice-White - Brighter)
        "#ffffff", -- White (Snow)
    },
    -- Bright ANSI colors (very high contrast)
    brights = {
        "#233932", -- Black
        "#ff9ea8", -- Red
        "#b0f0d3", -- Green
        "#fcf1c5", -- Yellow
        "#d4ebf7", -- Blue
        "#d6cdeb", -- Magenta
        "#dcf5fc", -- Cyan
        "#ffffff", -- White
    },
    indexed = {
        [16] = "#ebd69b", -- Winter Sun
        [17] = "#ff9ea8", -- Bright Berry Red
    },
}
