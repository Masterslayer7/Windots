-- Initialize Configuration
local wezterm = require("wezterm")
local config = wezterm.config_builder()
local act = wezterm.action

-- Load custom tabs module
require("tabs").setup(config)

------------------------------------------------------------
-- OS Detection
------------------------------------------------------------
local function get_os()
    if wezterm.target_triple:find("windows") then
        return "windows"
    elseif wezterm.target_triple:find("linux") then
        return "linux"
    end
    return "macos"
end
local host_os = get_os()

------------------------------------------------------------
-- Seamless Neovim ↔ WezTerm Pane Navigation
------------------------------------------------------------
local function is_vim(pane)
    local process_info = pane:get_foreground_process_info()
    local process_name = process_info and process_info.name
    return process_name == "nvim" or process_name == "vim"
end

local direction_keys = {
    h = "Left",
    j = "Down",
    k = "Up",
    l = "Right",
}

local function split_nav(resize_or_move, key)
    return {
        key = key,
        mods = resize_or_move == "resize" and "ALT" or "CTRL",
        action = wezterm.action_callback(function(win, pane)
            if is_vim(pane) then
                win:perform_action(
                    act.SendKey({ key = key, mods = resize_or_move == "resize" and "ALT" or "CTRL" }),
                    pane
                )
            else
                if resize_or_move == "resize" then
                    win:perform_action(act.AdjustPaneSize({ direction_keys[key], 3 }), pane)
                else
                    win:perform_action(act.ActivatePaneDirection(direction_keys[key]), pane)
                end
            end
        end),
    }
end

------------------------------------------------------------
-- Font Configuration
------------------------------------------------------------
local emoji_font = "Segoe UI Emoji"
if host_os == "linux" then
    emoji_font = "Noto Color Emoji"
end

config.font = wezterm.font_with_fallback({
    { family = "JetBrainsMonoNL NFM", weight = "Regular" },
    emoji_font,
})
config.font_size = 10

------------------------------------------------------------
-- Color Configuration
------------------------------------------------------------
local opacity = 0.60
local transparent_bg = "rgba(3, 25, 27, " .. opacity .. ")"
config.colors = require("cyberdream")
config.colors.split = "#083d44" -- Dark teal border for thin split dividers
config.force_reverse_video_cursor = true

-- Dim inactive panes slightly to make the active pane pop
config.inactive_pane_hsb = {
    saturation = 0.8,
    brightness = 0.75,
}

------------------------------------------------------------
-- Window Configuration
------------------------------------------------------------
config.initial_rows = 45
config.initial_cols = 180

-- Window decorations and titlebar controls
config.window_decorations = "TITLE | RESIZE"

-- Opacity and blurred background
config.window_background_opacity = opacity
config.window_background_image = wezterm.config_dir .. "/bg-blurred.jpg"
config.window_background_image_hsb = {
    brightness = 0.12, -- Dimmed so text contrast remains extremely high
    saturation = 0.4,
}

-- Spacious text margins
config.window_padding = {
    left = 15,
    right = 15,
    top = 12,
    bottom = 12,
}

config.window_close_confirmation = "NeverPrompt"
config.win32_system_backdrop = "Acrylic"

------------------------------------------------------------
-- Performance Settings
------------------------------------------------------------
config.max_fps = 144
config.animation_fps = 60
config.cursor_blink_rate = 250

------------------------------------------------------------
-- Tab Bar Configuration
------------------------------------------------------------
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false
config.show_tab_index_in_tab_bar = false
config.use_fancy_tab_bar = false

config.window_frame = {
    font = wezterm.font_with_fallback({
        { family = "JetBrainsMonoNL NFM", weight = "Bold" },
        emoji_font,
    }),
    font_size = 9.0,
}

config.colors.tab_bar = {
    background = transparent_bg,
    new_tab = { fg_color = "#7b8496", bg_color = "#25282e" },
    new_tab_hover = { fg_color = "#16181a", bg_color = "#5ef1ff" },
}

------------------------------------------------------------
-- Leader Key: Ctrl + Space
------------------------------------------------------------
config.leader = { key = "Space", mods = "CTRL", timeout_milliseconds = 1000 }

------------------------------------------------------------
-- Keybindings
------------------------------------------------------------
config.keys = {
    -- ═══════════════════════════════════════════════════════
    -- Seamless Neovim Navigation (Ctrl + h/j/k/l)
    -- Seamless Pane Resizing    (Alt + h/j/k/l)
    -- ═══════════════════════════════════════════════════════
    split_nav("move", "h"),
    split_nav("move", "j"),
    split_nav("move", "k"),
    split_nav("move", "l"),
    split_nav("resize", "h"),
    split_nav("resize", "j"),
    split_nav("resize", "k"),
    split_nav("resize", "l"),

    -- ═══════════════════════════════════════════════════════
    -- Tmux-Style Split Panes  (Leader then key)
    -- ═══════════════════════════════════════════════════════
    -- Split right  (side-by-side)
    { key = "|", mods = "LEADER|SHIFT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
    { key = "\\", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },

    -- Split down   (top-and-bottom)
    { key = "-", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },

    -- ═══════════════════════════════════════════════════════
    -- Pane Focus  (Leader + Arrow Keys)
    -- ═══════════════════════════════════════════════════════
    { key = "LeftArrow", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
    { key = "RightArrow", mods = "LEADER", action = act.ActivatePaneDirection("Right") },
    { key = "UpArrow", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
    { key = "DownArrow", mods = "LEADER", action = act.ActivatePaneDirection("Down") },

    -- ═══════════════════════════════════════════════════════
    -- Pane Management
    -- ═══════════════════════════════════════════════════════
    { key = "z", mods = "LEADER", action = act.TogglePaneZoomState },
    { key = "x", mods = "LEADER", action = act.CloseCurrentPane({ confirm = true }) },
    { key = "q", mods = "LEADER", action = act.PaneSelect({ mode = "Activate" }) },

    -- ═══════════════════════════════════════════════════════
    -- Tabs
    -- ═══════════════════════════════════════════════════════
    { key = "c", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
    { key = "n", mods = "LEADER", action = act.ActivateTabRelative(1) },
    { key = "p", mods = "LEADER", action = act.ActivateTabRelative(-1) },

    -- Leader + 1-9 to jump to tab by index
    { key = "1", mods = "LEADER", action = act.ActivateTab(0) },
    { key = "2", mods = "LEADER", action = act.ActivateTab(1) },
    { key = "3", mods = "LEADER", action = act.ActivateTab(2) },
    { key = "4", mods = "LEADER", action = act.ActivateTab(3) },
    { key = "5", mods = "LEADER", action = act.ActivateTab(4) },
    { key = "6", mods = "LEADER", action = act.ActivateTab(5) },
    { key = "7", mods = "LEADER", action = act.ActivateTab(6) },
    { key = "8", mods = "LEADER", action = act.ActivateTab(7) },
    { key = "9", mods = "LEADER", action = act.ActivateTab(8) },

    -- ═══════════════════════════════════════════════════════
    -- Copy Mode & Clipboard
    -- ═══════════════════════════════════════════════════════
    { key = "[", mods = "LEADER", action = act.ActivateCopyMode },
    { key = "v", mods = "CTRL", action = act.PasteFrom("Clipboard") },

    -- ═══════════════════════════════════════════════════════
    -- Send raw Ctrl+Space to terminal (press leader twice)
    -- ═══════════════════════════════════════════════════════
    { key = "Space", mods = "LEADER|CTRL", action = act.SendKey({ key = "Space", mods = "CTRL" }) },

    -- ═══════════════════════════════════════════════════════
    -- General Shortcuts
    -- ═══════════════════════════════════════════════════════
    { key = "x", mods = "CTRL|SHIFT", action = act.CloseCurrentTab({ confirm = false }) },
}

------------------------------------------------------------
-- Default Shell / Launch Menu
------------------------------------------------------------
config.default_prog = { "pwsh", "-NoLogo" }

config.launch_menu = {
    { label = "PowerShell Core", args = { "pwsh", "-NoLogo" } },
    { label = "WSL", args = { "wsl.exe", "--cd", "~" } },
    { label = "Command Prompt", args = { "cmd.exe" } },
}

------------------------------------------------------------
-- OS-Specific Overrides
------------------------------------------------------------
if host_os == "windows" then
    config.default_prog = { "C:\\Windows\\System32\\wsl.exe", "--cd", "~" }
elseif host_os == "linux" then
    config.default_prog = { "zsh" }
    config.front_end = "WebGpu"
    config.window_decorations = nil
end

return config
