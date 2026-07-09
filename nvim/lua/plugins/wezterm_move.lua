return {
    "letieu/wezterm-move.nvim",
    keys = {
        { "<C-h>", function() require("wezterm-move").move("h") end, desc = "Move Left" },
        { "<C-j>", function() require("wezterm-move").move("j") end, desc = "Move Down" },
        { "<C-k>", function() require("wezterm-move").move("k") end, desc = "Move Up" },
        { "<C-l>", function() require("wezterm-move").move("l") end, desc = "Move Right" },
    },
}
