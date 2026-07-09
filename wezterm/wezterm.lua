-- Initialize Configuration
local wezterm = require("wezterm")
local config = wezterm.config_builder()
local opacity = 0.85
local transparent_bg = "rgba(22, 24, 26, " .. opacity .. ")"

--- Get the current operating system using target_triple
--- @return "windows"| "linux" | "macos"
local function get_os()
    if wezterm.target_triple:find("windows") then
        return "windows"
    elseif wezterm.target_triple:find("linux") then
        return "linux"
    end
    return "macos"
end

local host_os = get_os()

-- Font Configuration
local emoji_font = "Segoe UI Emoji"
if host_os == "linux" then
    emoji_font = "Noto Color Emoji"
end

config.font = wezterm.font_with_fallback({
    {
        family = "JetBrains Mono",
        weight = "Regular",
    },
    emoji_font,
})
config.font_size = 10

-- Color Configuration
config.colors = require("cyberdream")
config.force_reverse_video_cursor = true

-- Window Configuration
config.initial_rows = 45
config.initial_cols = 180
config.window_decorations = "INTEGRATED_BUTTONS | RESIZE"
config.window_background_opacity = opacity
-- config.window_background_image = wezterm.config_dir .. "/bg-blurred.png"
config.window_close_confirmation = "NeverPrompt"
config.win32_system_backdrop = "Acrylic"

-- Performance Settings
config.max_fps = 144
config.animation_fps = 60
config.cursor_blink_rate = 250

-- Helper function to get clean tool name and icon
local function get_clean_info(tab)
    local title = tab.tab_title
    if not (title and #title > 0) then
        title = tab.active_pane.title
    end
    
    title = title:lower()
    
    if title:find("gemini") or title:find("antigravity") or title:find("agy") then
        return "✨", "Gemini"
    elseif title:find("claude") then
        return "🤖", "Claude"
    elseif title:find("gpt") or title:find("openai") then
        return "🧠", "ChatGPT"
    elseif title:find("nvim") or title:find("vim") then
        return "", "Neovim"
    elseif title:find("lazygit") then
        return "", "LazyGit"
    elseif title:find("git") then
        return "", "Git"
    elseif title:find("node") or title:find("npm") then
        return "", "Node"
    elseif title:find("python") or title:find("py") then
        return "", "Python"
    elseif title:find("pwsh") or title:find("powershell") then
        return "", "PowerShell"
    elseif title:find("cmd") then
        return "", "Cmd"
    elseif title:find("wsl") or title:find("ubuntu") or title:find("debian") or title:find("bash") or title:find("zsh") or title:find("fish") or title:find("@") or title:find("yugpatel") then
        return "", "WSL"
    end
    
    local name = title:gsub(".*\\", ""):gsub(".*/", "")
    if name == "" then
        name = "Terminal"
    else
        name = name:sub(1,1):upper() .. name:sub(2)
    end
    return "", name
end

-- Tab Bar Configuration
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false
config.show_tab_index_in_tab_bar = false
config.use_fancy_tab_bar = false

config.window_frame = {
    font = wezterm.font_with_fallback({
        {
            family = "JetBrains Mono",
            weight = "Bold",
        },
        emoji_font,
    }),
    font_size = 9.0,
}

config.colors.tab_bar = {
    background = transparent_bg,
    new_tab = { fg_color = "#7b8496", bg_color = "#25282e" },
    new_tab_hover = { fg_color = "#16181a", bg_color = "#5ef1ff" },
    
    -- Sleek Traffic Light styled window buttons matching Cyberdream
    window_close = { fg_color = "#ff6e5e", bg_color = "rgba(0,0,0,0)" },
    window_close_hover = { fg_color = "#16181a", bg_color = "#ff6e5e" },
    window_minimize = { fg_color = "#f1ff5e", bg_color = "rgba(0,0,0,0)" },
    window_minimize_hover = { fg_color = "#16181a", bg_color = "#f1ff5e" },
    window_maximize = { fg_color = "#5eff6c", bg_color = "rgba(0,0,0,0)" },
    window_maximize_hover = { fg_color = "#16181a", bg_color = "#5eff6c" },
}

-- Tab Formatting
wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover)
    local icon, name = get_clean_info(tab)

    local bg = "#25282e" -- Inactive tab background
    local fg = "#7b8496" -- Inactive tab text
    
    if tab.is_active then
        bg = "#5ef1ff" -- Active tab background (Cyan)
        fg = "#16181a" -- Active tab text
    elseif hover then
        bg = "#bd5eff" -- Hover tab background (Purple)
        fg = "#ffffff" -- Hover tab text
    end

    local tab_text = string.format(" %s %s ", icon, name)
    
    local cells = {}
    
    -- Add left padding space on the very first tab so it doesn't touch the window edge
    if tab.tab_index == 0 then
        table.insert(cells, { Background = { Color = transparent_bg } })
        table.insert(cells, { Text = " " })
    end
    
    table.insert(cells, { Background = { Color = transparent_bg } })
    table.insert(cells, { Foreground = { Color = bg } })
    table.insert(cells, { Text = "" })
    
    table.insert(cells, { Background = { Color = bg } })
    table.insert(cells, { Foreground = { Color = fg } })
    table.insert(cells, { Text = tab_text })
    
    table.insert(cells, { Background = { Color = transparent_bg } })
    table.insert(cells, { Foreground = { Color = bg } })
    table.insert(cells, { Text = "" })
    
    table.insert(cells, { Background = { Color = transparent_bg } })
    table.insert(cells, { Text = " " })
    
    return cells
end)

-- Keybindings
config.keys = {
    { key = "v", mods = "CTRL", action = wezterm.action.PasteFrom("Clipboard") },
}

-- Default Shell Configuration (fallback)
config.default_prog = { "pwsh", "-NoLogo" }

-- Launch Menu (right-click the '+' tab button to select)
config.launch_menu = {
    {
        label = "PowerShell Core",
        args = { "pwsh", "-NoLogo" },
    },
    {
        label = "WSL",
        args = { "wsl.exe", "--cd", "~" },
    },
    {
        label = "Command Prompt",
        args = { "cmd.exe" },
    },
}

-- OS-Specific Overrides
if host_os == "windows" then
    -- Drops you straight into your default WSL2 environment on Windows startup
    config.default_prog = { "C:\\Windows\\System32\\wsl.exe", "--cd", "~" }
elseif host_os == "linux" then
    config.default_prog = { "zsh" }
    config.front_end = "WebGpu"
    config.window_decorations = nil -- use system decorations
end

return config
