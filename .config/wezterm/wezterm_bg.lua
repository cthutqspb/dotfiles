-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

config.color_scheme = "Tokyo Night"

-- Добавь эти опции для прозрачности и отключения header (переопределят, если есть)
config.window_background_opacity = 0.0  -- Полная прозрачность фона (0.0 = 100% прозрачный)
config.window_decorations = "NONE"      -- Отключает заголовок (title bar) в WezTerm
config.enable_tab_bar = false           -- Отключает панель вкладок (tab bar)

config.front_end = "WebGpu"
config.animation_fps = 144
config.max_fps = 144
config.automatically_reload_config = true

config.font = wezterm.font("Terminess Nerd Font Mono", { weight = "Regular" })
config.freetype_render_target = "Light"
config.freetype_load_target = "Light"
--config.freetype_load_flags = "NO_BITMAP"
config.font_size = 15
config.line_height = 0.74
config.cell_width = 0.90

return config
