-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices
-- local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")
--tabline.setup({
--  options = {
--    theme = "Tokyo Night"
--  }
--})

--tabline.apply_to_config(config)
-- For example, changing the color scheme:

-- config.color_scheme = 'Wryan'
-- config.color_scheme = 'Unikitty Dark (base16)'
config.color_scheme = "Tokyo Night"
-- config.color_scheme = 'Teva (terminal.sexy)'
--  config.color_scheme = 'Solarized Dark - Patched'
-- config.color_scheme = 'Shaman'
-- config.color_scheme = 'Sea Shells (Gogh)'
-- config.color_scheme = 'Kasugano (terminal.sexy)'
-- config.color_scheme = 'Icy Dark (base16)'
-- config.color_scheme = 'Frontend Galaxy (Gogh)'
-- config.color_scheme = 'Framer'
-- config.color_scheme = 'ForestBlue'
-- config.color_scheme = 'FarSide (terminal.sexy)'
--  config.color_scheme = 'Codeschool (dark) (terminal.sexy)'
-- config.color_scheme = 'Cobalt Neon'
-- config.color_scheme = 'carbonfox'
-- 'AtelierSulphurpool'
-- config.color_scheme = 'Atelier Sulphurpool (base16)'

-- window_decorations = "RESIZE"

--[colors]
--foreground = "#c2caf1"
--background = "#1a1b25"
--cursor_bg = "#c2caf1"
--cursor_border = "#c2caf1"
--cursor_fg = "#1a1b25"
--selection_bg = "#2a3454"
--selection_fg = "#c2caf1"

--ansi = ["#15161d","#e77d8f","#a8cd76","#d8b172","#82a1f1","#b69bf1","#90cdfa","#aab1d3"]
--brights = ["#424866","#e77d8f","#a8cd76","#d8b172","#82a1f1","#b69bf1","#90cdfa","#c2caf1"]
local colors_palette = {
  color_00 = "#15161d",
  color_01 = "#e77d8f",
  color_02 = "#a8cd76",
  color_03 = "#d8b172",
  color_04 = "#82a1f1",
  color_05 = "#b69bf1",
  color_06 = "#90cdfa",
  color_07 = "#aab1d3",
}

local background_main_color = "rgba: 25 27 38 72%"

config.front_end = "WebGpu"
config.animation_fps = 144
config.max_fps = 144
config.window_background_opacity = 0.72
config.automatically_reload_config = true
window_background_blur = 30

config.font = wezterm.font("Terminess Nerd Font Mono", { weight = "Regular" })
-- config.font = wezterm.font("iMWritingMono Nerd Font Mono", { weight = "Regular" })
--config.font = wezterm.font("Hasklug Nerd Font Mono", { weight = "Regular" })

-- config.dpi = 96.0
config.font_size = 15
config.line_height = 0.72
config.cell_width = 0.9

config.show_close_tab_button_in_tabs = false
config.use_fancy_tab_bar = false
config.status_update_interval = 1000
config.window_close_confirmation = "AlwaysPrompt"
config.scrollback_lines = 5000
config.cursor_blink_rate = 250
--config.tab_and_split_indices_are_zero_based = false

config.window_frame = {
  inactive_titlebar_bg = background_main_color,
  -- inactive_titlebar_bg = "rgba: 25% 27% 38% 100%",
  active_titlebar_bg = background_main_color,
  -- font_size = 12,
  -- active_titlebar_bg = "none",
}

wezterm.on("update-status", function(window, pane)
  -- Workspace name
  local stat = window:active_workspace()
  local stat_color = "#f7768e"
  -- It's a little silly to have workspace name all the time
  -- Utilize this to display LDR or current key table name
  if window:active_key_table() then
    stat = window:active_key_table()
    stat_color = "#7dcfff"
  end
  if window:leader_is_active() then
    stat = "LDR"
    stat_color = "#bb9af7"
  end

  local basename = function(s)
    -- Nothing a little regex can't fix
    return string.gsub(s, "(.*[/\\])(.*)", "%2")
  end

  -- Current working directory
  local cwd = pane:get_current_working_dir()
  if cwd then
    cwd = basename(cwd.file_path) --> URL object introduced in 20240127-113634-bbcac864 (type(cwd) == "userdata")
    -- cwd = basename(cwd) --> 20230712-072601-f4abf8fd or earlier version
  else
    cwd = ""
  end

  -- Current command
  local cmd = pane:get_foreground_process_name()
  -- CWD and CMD could be nil (e.g. viewing log using Ctrl-Alt-l)
  cmd = cmd and basename(cmd) or ""

  -- Left status (left of the tab line)
  window:set_left_status(wezterm.format({
    { Background = { Color = background_main_color } },
    { Foreground = { Color = stat_color } },
    { Text = "  " },
    { Text = wezterm.nerdfonts.oct_table .. "  " .. stat },
    { Text = " |" },
  }))

  -- Right status
  window:set_right_status(wezterm.format({
    -- Wezterm has a built-in nerd fonts
    -- https://wezfurlong.org/wezterm/config/lua/wezterm/nerdfonts.html
    { Background = { Color = background_main_color } },
    { Foreground = { Color = colors_palette.color_04 } },
    { Text = " " .. cwd .. wezterm.nerdfonts.md_folder .. "  " .. cwd },
    { Text = " | " },
    { Background = { Color = background_main_color } },
    { Foreground = { Color = "#e0af68" } },
    { Text = wezterm.nerdfonts.fa_code .. "  " .. cmd },
    { Text = "  " },
  }))
end)

-- This function returns the suggested title for a tab.
-- It prefers the title that was set via `tab:set_title()`
-- or `wezterm cli set-tab-title`, but falls back to the
-- title of the active pane in that tab.
function tab_title(tab_info)
  local title = tab_info.tab_title
  -- if the tab title is explicitly set, take that
  if title and #title > 0 then
    return title
  end
  -- Otherwise, use the title from the active pane
  -- in that tab
  return tab_info.active_pane.title
end

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local background = background_main_color
  local foreground = colors_palette.color_04

  if tab.is_active then
    background = background_main_color
    foreground = colors_palette.color_03
  elseif hover then
    background = background_main_color
    foreground = colors_palette.color_06
  end

  local title = tab_title(tab)
  local id = tab.tab_index
  -- ensure that the titles fit in the available space,
  -- and that we have room for the edges.
  title = wezterm.truncate_right(title, max_width + 0)

  return {
    { Background = { Color = background_main_color } },
    { Foreground = { Color = foreground } },
    { Text = " " .. id .. ": " .. title .. " " },
  }
end)

config.tab_bar_style = {
  new_tab = wezterm.format({
    { Background = { Color = background_main_color } },
    { Foreground = { Color = colors_palette.color_04 } },
    { Text = " + " },
    { Attribute = { Intensity = "Bold" } },
  }),
  -- new_tab_hover = wezterm.format {
  --   { Background = { Color = colors_palette.color_03 } },
  --   { Foreground = { Color = colors_palette.color_06 } },
  -- }
}

-- Keys
config.keys = {
  -- This will create a new split and run your default program inside it
  {
    key = "o",
    mods = "CTRL|SHIFT",
    action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
  },
  {
    key = "e",
    mods = "CTRL|SHIFT",
    action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
  },
}

-- and finally, return the configuration to wezterm
return config
