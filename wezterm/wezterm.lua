-- Initialize Configuration
local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Load custom tabs module
require("tabs").setup(config)
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

-- Helper function to check if Neovim/Vim is running in active pane
local function is_vim(pane)
    local process_info = pane:get_foreground_process_info()
    local process_name = process_info and process_info.name
    return process_name == "nvim" or process_name == "vim"
end

local direction_keys = {
    Left = "h", Down = "j", Up = "k", Right = "l",
    h = "Left", j = "Down", k = "Up", l = "Right",
}

-- Custom event logic for seamless move/resize between terminal panes and Neovim
local function split_nav(resize_or_move, key)
    return {
        key = key,
        mods = resize_or_move == "resize" and "ALT" or "CTRL",
        action = wezterm.action_callback(function(win, pane)
            if is_vim(pane) then
                win:perform_action({
                    SendKey = { key = key, mods = resize_or_move == "resize" and "ALT" or "CTRL" },
                }, pane)
            else
                if resize_or_move == "resize" then
                    win:perform_action({ AdjustPaneSize = { direction_keys[key], 3 } }, pane)
                else
                    win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
                end
            end
        end),
    }
end

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
}


-- Set Ctrl+a as the leader key (matches tmux prefix)
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }

-- Keybindings
config.keys = {
    -- Seamless Navigation (Ctrl + h/j/k/l) & Resizing (Alt + h/j/k/l) with Neovim
    split_nav("move", "h"),
    split_nav("move", "j"),
    split_nav("move", "k"),
    split_nav("move", "l"),
    split_nav("resize", "h"),
    split_nav("resize", "j"),
    split_nav("resize", "k"),
    split_nav("resize", "l"),

    -- Send Ctrl+a to terminal by pressing Ctrl+a twice
    { key = "a", mods = "LEADER|CTRL", action = wezterm.action.SendKey({ key = "a", mods = "CTRL" }) },

    -- Split panes (matching tmux keys)
    { key = "%", mods = "LEADER", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
    { key = '"', mods = "LEADER", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },

    -- Move focus between panes (matching tmux keys)
    { key = "h", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Left") },
    { key = "l", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Right") },
    { key = "k", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Up") },
    { key = "j", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Down") },

    -- Zoom/Toggle pane (matching tmux key)
    { key = "z", mods = "LEADER", action = wezterm.action.TogglePaneZoomState },

    -- Tabs (matching tmux keys)
    { key = "c", mods = "LEADER", action = wezterm.action.SpawnTab("CurrentPaneDomain") },
    { key = "p", mods = "LEADER", action = wezterm.action.ActivateTabRelative(-1) },
    { key = "n", mods = "LEADER", action = wezterm.action.ActivateTabRelative(1) },

    -- Close active pane (matching tmux key)
    { key = "x", mods = "LEADER", action = wezterm.action.CloseCurrentPane({ confirm = false }) },

    -- General shortcuts
    { key = "v", mods = "CTRL", action = wezterm.action.PasteFrom("Clipboard") },
    { key = "x", mods = "CTRL|SHIFT", action = wezterm.action.CloseCurrentTab({ confirm = false }) },
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
