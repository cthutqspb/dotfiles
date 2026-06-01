-- ============================================================================
-- HYPRLAND CONFIG (Lua версия)
-- Конвертировано из hyprland.conf
-- ============================================================================

-- ----------------------------------------------------------------------------
-- ПЕРЕМЕННЫЕ
-- ----------------------------------------------------------------------------
local terminal = "wezterm"
local fileManager = "thunar"
local menu = "rofi --show drun"

-- ----------------------------------------------------------------------------
-- ENVIRONMENT VARIABLES
-- ----------------------------------------------------------------------------
-- Базовые переменные окружения
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
-- Аппаратное ускорение NVIDIA
hl.env("GBM_BACKEND", "nvidia-drm")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("__GL_VRR_ALLOWED", "1")

-- hl.env("LIBVA_DRIVER_NAME", "nvidia")
-- hl.env("XDG_SESSION_TYPE", "wayland")
--hl.env("LIBVA_DRIVER_NAME", "nvidia")

-- Исправление проблем с Wayland + NVIDIA (Обновлено под Aquamarine для 0.55+)
-- hl.env("AQ_NO_ATOMIC", "1") -- Замена старого WLR_DRM_NO_ATOMIC, если мерцает экран

-- VRR (G-Sync)
--hl.env("__GL_VRR_ALLOWED", "1")

-- Убирает микро-заикания анимаций, принудительно выравнивая буфер кадров
--hl.env("AQ_NO_MODIFIERS", "1")

-- Для игр через Wine
--hl.env("WINE_FULLSCREEN_FSR", "1")

-- Экспериментальные (NVIDIA NVK / Direct)
-- hl.env("NVD_BACKEND", "direct")

-- Курсоры
--hl.env("XCURSOR_SIZE", "24")
-- hl.env("HYPRCURSOR_SIZE", "24")

-- ----------------------------------------------------------------------------
-- ОСНОВНЫЕ НАСТРОЙКИ
-- ----------------------------------------------------------------------------
hl.config({
	general = {
		gaps_in = 4,
		gaps_out = 8,
		border_size = 1,
		-- В 0.55+ градиенты пишутся СТРОГО через таблицу { colors = {}, angle = ... }
		col = {
			active_border = {
				colors = { "rgba(27,72,97,0.72)", "rgba(38,139,211,0.42)" },
				angle = 45,
			},
			inactive_border = { colors = { "rgba(27,72,97,0.97)" } },
		},
		resize_on_border = false,
		allow_tearing = false,
		layout = "dwindle",
	},

	render = {
		new_render_scheduling = true, -- Включает умный планировщик кадров для плавности
		-- Отключает прямой вывод кадра, возвращая контроль над цветом композитору
		-- direct_scanout = false
	},

	decoration = {
		rounding = 0,
		rounding_power = 2,
		active_opacity = 1.0,
		inactive_opacity = 1.0,
		-- Названия параметров теней изменены (убран префикс drop_)
		shadow = {
			enabled = true,
			range = 4,
			render_power = 3,
			color = "rgba(1a1a1aee)",
		},
		blur = {
			enabled = true,
			size = 3,
			passes = 2,
			vibrancy = 0.1696,
		},
	},

	dwindle = {
		preserve_split = true,
		-- Примечание: dwindle.pseudotile был полностью УДАЛЕН в 0.55
	},

	master = {
		new_status = "master",
	},

	misc = {
		force_default_wallpaper = -1,
		disable_hyprland_logo = true,
		disable_splash_rendering = true,
	},

	input = {
		kb_layout = "us, ru",
		kb_options = "grp:alt_shift_toggle",
		follow_mouse = 1,
		sensitivity = 0,
		touchpad = {
			natural_scroll = false,
		},
	},

	xwayland = {
		force_zero_scaling = true,
	},

	cursor = {
		no_hardware_cursors = 1, -- or true, depending on the wrapper
	},
})

-- =========================================================================
-- КРИВЫЕ АНИМАЦИИ (hl.curve) - Вынесены из hl.config в 0.55+
-- =========================================================================
hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1.0 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

-- =========================================================================
-- САМИ АНИМАЦИИ (hl.animation) - Вынесены из hl.config в 0.55+
-- =========================================================================
hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows", enabled = true, speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.1, bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })

-- =========================================================================
-- МОНИТОРЫ (hl.monitor принимает ОДНУ таблицу с именованными ключами)
-- =========================================================================
hl.monitor({ output = "DP-1", mode = "2560x1440@143.91", position = "0x0", scale = 1 })
hl.monitor({ output = "DP-2", mode = "2560x1440@144", position = "2560x0", scale = 1 })
hl.monitor({ output = "DP-3", mode = "1920x1080@144", position = "5120x0", scale = 1 })

-- =========================================================================
-- РАБОЧИЕ СТОЛЫ (Используется функция hl.workspace_rule)
-- =========================================================================
hl.workspace_rule({ workspace = "1", monitor = "DP-1" })
hl.workspace_rule({ workspace = "2", monitor = "DP-2", default = true })
hl.workspace_rule({ workspace = "3", monitor = "DP-3" })

-- =========================================================================
-- ПРАВИЛА ДЛЯ ОКОН (hl.window_rule)
-- =========================================================================

-- btop-term
hl.window_rule({
	match = { class = "btop-term" },
	float = true,
	size = { 1920, 1080 },
	move = { 0, 0 },
	monitor = "DP-3",
	workspace = "3",
	no_initial_focus = true,
	no_focus = true, -- Полный запрет фокуса при кликах
	--no_input_shaping = 1,  -- МЫШЬ ПРОХОДИТ СКВОЗЬ ОКНО (Окно некликабельно)
	no_shadow = true,
	no_blur = 1,
	opacity = 0.72,
})

-- wttr-term
hl.window_rule({
	match = { class = "wttr-term" },
	float = true,
	size = { 540, 150 },
	move = { 50, 40 },
	monitor = "DP-3",
	workspace = "3",
	no_initial_focus = true,
	no_focus = true, -- Полный запрет фокуса при кликах
	-- no_input_shaping = true,  -- МЫШЬ ПРОХОДИТ СКВОЗЬ ОКНО (Окно некликабельно)
	no_shadow = true,
	animation = "none",
})

-- center-term
hl.window_rule({
	match = { class = "center-term" },
	workspace = "2",
	no_shadow = true,
	-- noblur = true,
	opacity = 1.0,
	no_blur = 1.0,
})

-- Chromium
hl.window_rule({
	match = { class = "Chromium" },
	opacity = 1.0,
})

-- =========================================================================
-- БИНДЫ КЛАВИШ (hl.bind)
-- =========================================================================
local mod = "SUPER"

-- Правильный синтаксис 0.55+ (Передаем диспетчер напрямую без function())
hl.bind(mod .. " + Q", hl.dsp.exec_cmd(terminal))
hl.bind(mod .. " + C", hl.dsp.window.close())
hl.bind(mod .. " + M", hl.dsp.exit())
hl.bind(mod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mod .. " + P", hl.dsp.window.pseudo({ action = "toggle" }))
-- Разворачивание окна в пределах тайла (с сохранением статусбара и гэпов)
hl.bind(mod .. " + H", hl.dsp.window.fullscreen({ action = "toggle", mode = "maximized" }))

-- Перемещение фокуса
for key, dir in pairs({ left = "l", right = "r", up = "u", down = "d" }) do
	hl.bind(mod .. " + " .. key, function()
		hl.dsp.focus({ direction = dir })
	end)
end

-- Переключение рабочих столов (Номер стола пишется строкой!)
for i = 1, 9 do
	hl.bind(mod .. " + " .. i, function()
		hl.dsp.focus({ workspace = tostring(i) })
	end)
	hl.bind(mod .. " + SHIFT + " .. i, function()
		hl.dsp.window.move({ workspace = tostring(i) })
	end)
end
hl.bind(mod .. " + 0", function()
	hl.dsp.focus({ workspace = "10" })
end)
hl.bind(mod .. " + SHIFT + 0", function()
	hl.dsp.window.move({ workspace = "10" })
end)

-- Специальный рабочий стол (scratchpad)
hl.bind(mod .. " + S", function()
	hl.dsp.focus({ workspace = "special:magic" })
end)
hl.bind(mod .. " + SHIFT + S", function()
	hl.dsp.window.move({ workspace = "special:magic" })
end)

-- Скролл по рабочим столам (Колесико мыши)
hl.bind(mod .. " + mouse_down", function()
	hl.dsp.focus({ workspace = "m+1" })
end) -- В 0.55 используется m+1/m-1 относительно монитора
hl.bind(mod .. " + mouse_up", function()
	hl.dsp.focus({ workspace = "m-1" })
end)

-- Перемещение окон: SUPER + зажатая Левая кнопка мыши (LMB)
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
-- Изменение размера: SUPER + зажатая Правая кнопка мыши (RMB)
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Дополнительные бинды (Тоже без оберток)
hl.bind(mod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mod .. " + F", hl.dsp.window.fullscreen({ action = "toggle" }))
hl.bind(mod .. " + R", hl.dsp.exec_cmd("rofi -show drun"))
hl.bind(mod .. " + E", hl.dsp.exec_cmd("syspower -m 1"))
hl.bind("Print", hl.dsp.exec_cmd('grim -g "$(slurp -d)" - | wl-copy'))

-- Циклическое переключение окон
hl.bind("ALT + Tab", function()
	hl.dsp.window.cycle_next()
	hl.dsp.window.alter_zorder({ mode = "top" })
end)

-- Управление MPD
hl.bind(mod .. " + F1", function()
	hl.exec_cmd("mpc prev")
end)
hl.bind(mod .. " + F2", function()
	hl.exec_cmd("mpc next")
end)

-- =========================================================================
-- МУЛЬТИМЕДИЙНЫЕ КЛАВИШИ (hl.bind + флаг locked)
-- =========================================================================

-- Громкость
hl.bind("XF86AudioRaiseVolume", function()
	hl.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+")
end, { locked = true })

hl.bind("XF86AudioLowerVolume", function()
	hl.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-")
end, { locked = true })

hl.bind("XF86AudioMute", function()
	hl.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle")
end, { locked = true })

hl.bind("XF86AudioMicMute", function()
	hl.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle")
end, { locked = true })

-- Яркость
hl.bind("XF86MonBrightnessUp", function()
	hl.exec_cmd("brightnessctl s 10%+")
end, { locked = true })

hl.bind("XF86MonBrightnessDown", function()
	hl.exec_cmd("brightnessctl s 10%-")
end, { locked = true })

-- Медиаплеер
hl.bind("XF86AudioNext", function()
	hl.exec_cmd("playerctl next")
end, { locked = true })
hl.bind("XF86AudioPause", function()
	hl.exec_cmd("playerctl play-pause")
end, { locked = true })
hl.bind("XF86AudioPlay", function()
	hl.exec_cmd("playerctl play-pause")
end, { locked = true })
hl.bind("XF86AudioPrev", function()
	hl.exec_cmd("playerctl previous")
end, { locked = true })

-- =========================================================================
-- АВТОЗАПУСК (Безопасный вариант через хук hyprland.start)
-- =========================================================================

-- hl.on гарантирует, что код внутри выполнится ОДИН РАЗ при загрузке системы,
-- и НЕ БУДЕТ перезапускаться при сохранениях файла в nvim.
hl.on("hyprland.start", function()
	-- 1. Основные фоновые приложения стартуют сразу
	-- hl.exec_cmd("wlsunset -l 59.93863 -L 30.31413")
	hl.exec_cmd("hyprsunset")
	hl.exec_cmd("waybar")
	hl.exec_cmd("Telegram")
	hl.exec_cmd("discord")
	hl.exec_cmd("hyprpaper")
	hl.exec_cmd("openrgb -p white")
	hl.exec_cmd("nm-applet --indicator")

	-- 2. Таймеры отложенного запуска (теперь они безопасно изолированы внутри хука)
	hl.timer(function()
		hl.exec_cmd("wezterm --config-file ~/.config/wezterm/wezterm_bg.lua start --class btop-term -- btop")
	end, { timeout = 2000, type = "oneshot" })

	hl.timer(function()
		hl.exec_cmd(
			"wezterm --config-file ~/.config/wezterm/wezterm_bg.lua start --class wttr-term -- ~/.config/scripts/weather-rustormy.sh"
		)
	end, { timeout = 5000, type = "oneshot" })

	hl.timer(function()
		hl.exec_cmd("wezterm --config-file ~/.config/wezterm/wezterm_autostart.lua start --class center-term")
	end, { timeout = 2000, type = "oneshot" })

	hl.timer(function()
		hl.dsp.focus({ workspace = "2" })
	end, { timeout = 3000, type = "oneshot" })

	-- Костыль для багов курсора 0.55+ (срабатывает один раз через 2 секунды после логина)
	hl.timer(function()
		-- Слегка "шевелим" настройки третьего монитора, чтобы сбросить невидимую стену
		hl.monitor({ output = "DP-3", mode = "1920x1080@144", position = "5120x0", scale = 1 })
	end, { timeout = 2000, type = "oneshot" })
end)

-- ----------------------------------------------------------------------------
-- ПРИМЕРЫ ПРОДВИНУТЫХ ФИШ (раскомментируй, если нужно)
-- ----------------------------------------------------------------------------

-- Автоматическое переключение на рабочий стол 2 после запуска center-term
-- hl.on("window.created", function(win)
--     if win.class == "center-term" then
--         hl.timer(function() hl.dsp.workspace(2) end, { timeout = 500, once = true })
--     end
-- end)

-- Отслеживание изменений громкости
-- hl.on("audio.volume", function(volume)
--     print("Громкость изменена на: " .. volume .. "%")
-- end)

print("Hyprland Lua config loaded successfully!")
