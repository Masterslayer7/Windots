local wezterm = require("wezterm")

local M = {}

------------------------------------------------------------
-- Cyberdream Palette
------------------------------------------------------------
local colors = {
    bg          = "#0a110f", -- Spruce green-black
    surface     = "#131f1c", -- Dark forest green
    overlay     = "#1b2b27", -- Medium forest green
    muted       = "#2b3f3a", -- Slate forest
    subtle      = "#89a89c", -- Frosted pine gray (Brighter for contrast)
    text        = "#ffffff", -- Pure snow white text (Maximum contrast)
    cyan        = "#bce6f2", -- Glacial ice-white cyan (Active tab - Brighter)
    purple      = "#b8add1", -- Muted winter purple (Hover state - Brighter)
    green       = "#8fe4c1", -- Frosted spruce green (Brighter)
    pink        = "#e68595", -- Soft berry red
    yellow      = "#ebd69b", -- Pale winter sun yellow
    orange      = "#d9a473", -- Soft copper orange
    blue        = "#b3d3e3", -- Glacier ice-white blue (Brighter)
}

------------------------------------------------------------
-- Process Icons (Nerd Fonts)
------------------------------------------------------------
local process_icons = {
    ["nvim"]           = wezterm.nerdfonts.custom_vim,
    ["vim"]            = wezterm.nerdfonts.dev_vim,
    ["bash"]           = wezterm.nerdfonts.cod_terminal_bash,
    ["zsh"]            = wezterm.nerdfonts.dev_terminal,
    ["fish"]           = wezterm.nerdfonts.md_fish,
    ["sh"]             = wezterm.nerdfonts.cod_terminal_bash,
    ["pwsh"]           = wezterm.nerdfonts.md_console,
    ["pwsh.exe"]       = wezterm.nerdfonts.md_console,
    ["powershell"]     = wezterm.nerdfonts.md_console,
    ["powershell.exe"] = wezterm.nerdfonts.md_console,
    ["cmd.exe"]        = wezterm.nerdfonts.md_console_line,
    ["wsl.exe"]        = wezterm.nerdfonts.cod_terminal_linux,
    ["wslhost.exe"]    = wezterm.nerdfonts.cod_terminal_linux,
    ["git"]            = wezterm.nerdfonts.dev_git,
    ["lazygit"]        = wezterm.nerdfonts.cod_github,
    ["node"]           = wezterm.nerdfonts.md_nodejs,
    ["npm"]            = wezterm.nerdfonts.md_npm,
    ["python"]         = wezterm.nerdfonts.dev_python,
    ["python3"]        = wezterm.nerdfonts.dev_python,
    ["cargo"]          = wezterm.nerdfonts.dev_rust,
    ["go"]             = wezterm.nerdfonts.seti_go,
    ["lua"]            = wezterm.nerdfonts.seti_lua,
    ["ruby"]           = wezterm.nerdfonts.cod_ruby,
    ["docker"]         = wezterm.nerdfonts.linux_docker,
    ["docker-compose"] = wezterm.nerdfonts.linux_docker,
    ["kubectl"]        = wezterm.nerdfonts.linux_docker,
    ["htop"]           = wezterm.nerdfonts.md_chart_areaspline,
    ["btop"]           = wezterm.nerdfonts.md_chart_areaspline,
    ["btm"]            = wezterm.nerdfonts.md_chart_areaspline,
    ["sudo"]           = wezterm.nerdfonts.fa_hashtag,
    ["make"]           = wezterm.nerdfonts.seti_makefile,
    ["curl"]           = wezterm.nerdfonts.mdi_flattr,
    ["wget"]           = wezterm.nerdfonts.mdi_arrow_down_box,
    ["ssh"]            = wezterm.nerdfonts.md_server_network,
    ["man"]            = wezterm.nerdfonts.md_book_open_variant,
    ["less"]           = wezterm.nerdfonts.md_book_open_variant,
    ["cat"]            = wezterm.nerdfonts.md_file_document,
    ["bat"]            = wezterm.nerdfonts.md_file_document,
}

local default_icon = wezterm.nerdfonts.cod_terminal

------------------------------------------------------------
-- Extract process name and icon from a tab
------------------------------------------------------------
local function get_process(tab)
    local pane = tab.active_pane
    local process_name = pane.foreground_process_name or ""

    -- Strip path (works for both Windows backslash and Unix slash)
    process_name = process_name:gsub("(.*[/\\])(.*)", "%2")

    -- Strip .exe suffix for matching
    local match_name = process_name:gsub("%.exe$", "")

    local icon = process_icons[process_name] or process_icons[match_name] or default_icon
    return icon, match_name ~= "" and match_name or "terminal"
end

------------------------------------------------------------
-- Build tab title
------------------------------------------------------------
local function tab_title(tab, max_width)
    local icon, name = get_process(tab)

    -- Check if any pane is zoomed
    local is_zoomed = false
    for _, p in ipairs(tab.panes) do
        if p.is_zoomed then
            is_zoomed = true
            break
        end
    end

    local zoom_indicator = is_zoomed and wezterm.nerdfonts.cod_zoom_in .. " " or ""
    local index = tab.tab_index + 1
    local title = string.format(" %s%s %s:%s ", zoom_indicator, icon, index, name)

    return wezterm.truncate_right(title, max_width - 2)
end

------------------------------------------------------------
-- Setup: apply tab bar config and register format handler
------------------------------------------------------------
function M.setup(config)
    config.use_fancy_tab_bar = false
    config.tab_bar_at_bottom = false
    config.hide_tab_bar_if_only_one_tab = false
    config.tab_max_width = 36
    config.unzoom_on_switch_pane = true

    -- Powerline glyphs
    local LEFT_CAP  = wezterm.nerdfonts.ple_left_half_circle_thick
    local RIGHT_CAP = wezterm.nerdfonts.ple_right_half_circle_thick

    wezterm.on("format-tab-title", function(tab, tabs, _, _, hover, max_width)
        local title = tab_title(tab, max_width)

        local bg = colors.overlay
        local fg = colors.subtle
        local cap_color = colors.overlay

        if tab.is_active then
            bg = colors.cyan
            fg = colors.bg
            cap_color = colors.cyan
        elseif hover then
            bg = colors.purple
            fg = colors.text
            cap_color = colors.purple
        end

        -- Transparent background behind the pill caps
        local transparent = colors.bg

        return {
            -- Left rounded cap
            { Background = { Color = transparent } },
            { Foreground = { Color = cap_color } },
            { Text = LEFT_CAP },
            -- Tab body
            { Background = { Color = bg } },
            { Foreground = { Color = fg } },
            { Attribute = { Intensity = tab.is_active and "Bold" or "Normal" } },
            { Text = title },
            -- Right rounded cap
            { Background = { Color = transparent } },
            { Foreground = { Color = cap_color } },
            { Text = RIGHT_CAP },
            -- Spacer between tabs
            { Background = { Color = transparent } },
            { Text = " " },
        }
    end)
end

return M
