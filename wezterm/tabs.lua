local wezterm = require("wezterm") --[[@as Wezterm]]

local M = {}
M.arrow_solid = ""
M.arrow_thin = ""
M.icons = {
  ["C:\\WINDOWS\\system32\\cmd.exe"] = wezterm.nerdfonts.md_console_line,
  ["Topgrade"] = wezterm.nerdfonts.md_rocket_launch,
  ["bash"] = wezterm.nerdfonts.cod_terminal_bash,
  ["btm"] = wezterm.nerdfonts.mdi_chart_donut_variant,
  ["cargo"] = wezterm.nerdfonts.dev_rust,
  ["curl"] = wezterm.nerdfonts.mdi_flattr,
  ["docker"] = wezterm.nerdfonts.linux_docker,
  ["docker-compose"] = wezterm.nerdfonts.linux_docker,
  ["fish"] = wezterm.nerdfonts.md_fish,
  ["gh"] = wezterm.nerdfonts.dev_github_badge,
  ["git"] = wezterm.nerdfonts.dev_git,
  ["go"] = wezterm.nerdfonts.seti_go,
  ["htop"] = wezterm.nerdfonts.md_chart_areaspline,
  ["btop"] = wezterm.nerdfonts.md_chart_areaspline,
  ["kubectl"] = wezterm.nerdfonts.linux_docker,
  ["kuberlr"] = wezterm.nerdfonts.linux_docker,
  ["lazydocker"] = wezterm.nerdfonts.linux_docker,
  ["lua"] = wezterm.nerdfonts.seti_lua,
  ["make"] = wezterm.nerdfonts.seti_makefile,
  ["node"] = wezterm.nerdfonts.mdi_hexagon,
  ["nvim"] = wezterm.nerdfonts.custom_vim,
  ["pacman"] = " ",
  ["paru"] = " ",
  ["psql"] = wezterm.nerdfonts.dev_postgresql,
  ["pwsh.exe"] = wezterm.nerdfonts.md_console,
  ["ruby"] = wezterm.nerdfonts.cod_ruby,
  ["sudo"] = wezterm.nerdfonts.fa_hashtag,
  ["vim"] = wezterm.nerdfonts.dev_vim,
  ["wget"] = wezterm.nerdfonts.mdi_arrow_down_box,
  ["zsh"] = wezterm.nerdfonts.dev_terminal,
  ["lazygit"] = wezterm.nerdfonts.cod_github,
}

---@param tab MuxTabObj
---@param max_width number
function M.title(tab, max_width)
  local title = (tab.tab_title and #tab.tab_title > 0) and tab.tab_title or tab.active_pane.title
  
  -- Extract the process name (first word, stripping paths)
  local process = title:match("^(%S+)")
  if process then
    process = process:gsub(".*\\", ""):gsub(".*/", "")
  end

  local icon = nil
  if process and M.icons[process] then
    icon = M.icons[process]
  else
    -- Fallback matching for WSL, shells, and user prompts (e.g. yugp@PC)
    local lower_title = title:lower()
    if lower_title:find("wsl") or lower_title:find("ubuntu") or lower_title:find("@") then
      icon = wezterm.nerdfonts.linux_ubuntu or wezterm.nerdfonts.cod_terminal_bash
    elseif lower_title:find("bash") or lower_title:find("zsh") or lower_title:find("fish") then
      icon = wezterm.nerdfonts.cod_terminal_bash
    end
  end

  if icon then
    title = icon .. " " .. title
  end

  local is_zoomed = false
  for _, pane in ipairs(tab.panes) do
    if pane.is_zoomed then
      is_zoomed = true
      break
    end
  end
  if is_zoomed then
    title = " " .. title
  end

  title = wezterm.truncate_right(title, max_width - 3)
  return " " .. title .. " "
end

---@param config Config
function M.setup(config)
  config.use_fancy_tab_bar = false
  config.tab_bar_at_bottom = false
  config.hide_tab_bar_if_only_one_tab = false -- Always show tab bar so you can see icons
  config.tab_max_width = 32
  config.unzoom_on_switch_pane = true

  wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
    local title = M.title(tab, max_width)
    
    -- Hardcoded Cyberdream palette to avoid config.resolved_palette runtime crash
    local active_bg = "#5ef1ff" -- Cyan
    local active_fg = "#16181a" -- Dark
    local inactive_bg = "#25282e" -- Medium Dark
    local inactive_fg = "#7b8496" -- Gray
    local hover_bg = "#bd5eff" -- Purple
    local hover_fg = "#ffffff" -- White

    local bg = inactive_bg
    local fg = inactive_fg

    if tab.is_active then
      bg = active_bg
      fg = active_fg
    elseif hover then
      bg = hover_bg
      fg = hover_fg
    end

    local tab_idx = 1
    for i, t in ipairs(tabs) do
      if t.tab_id == tab.tab_id then
        tab_idx = i
        break
      end
    end
    local is_last = tab_idx == #tabs
    local next_tab = tabs[tab_idx + 1]
    local next_is_active = next_tab and next_tab.is_active
    local arrow = (tab.is_active or is_last or next_is_active) and M.arrow_solid or M.arrow_thin
    
    local arrow_bg = inactive_bg
    local arrow_fg = "#3c4048"

    if is_last then
      arrow_fg = tab.is_active and active_bg or inactive_bg
      arrow_bg = "rgba(0,0,0,0)" -- Transparent background for trailing spacer
    elseif tab.is_active then
      arrow_bg = inactive_bg
      arrow_fg = active_bg
    elseif next_is_active then
      arrow_bg = active_bg
      arrow_fg = inactive_bg
    end

    return {
      { Background = { Color = bg } },
      { Foreground = { Color = fg } },
      { Text = title },
      { Foreground = { Color = arrow_fg } },
      { Background = { Color = arrow_bg } },
      { Text = arrow },
    }
  end)
end

return M
