local wezterm = require("wezterm")
local act = wezterm.action
local config = {}

config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}
-- -----------------GENERAL APEARANCE-----------------
config.color_scheme = "Moonfly (Gogh)"
config.use_fancy_tab_bar = false
config.window_background_opacity = 0.97
config.hide_tab_bar_if_only_one_tab = true
config.initial_cols = 90
config.initial_rows = 30

--This changes the font outside the terminal (tabs)
config.window_frame = {
	font_size = 12,
}
-- --------------------------------------

-- -----------------CURSOR-----------------
--Cursor type
--Available options: SteadyBlock, BlinkingBlock, SteadyUnderline, BlinkingUnderline, SteadyBar, and BlinkingBar
config.default_cursor_style = "BlinkingBlock"
config.cursor_blink_rate = 600
--Animation = 1 disables effects and transitions (no GPU)
config.animation_fps = 1
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"
-- --------------------------------------

-- -----------------FONT-----------------
-- The 'font_with_fallback()' is needed dont use just 'font ='
config.font = wezterm.font_with_fallback({
	"IosevkaTerm NF",
	"JetBrains Mono",
})
--Differs from window_frame({font_size = }) This changes the font of the text inside the terminal
config.font_size = 13
-- --------------------------------------

-- -----------------OPTIONALS-----------------
--[[

--To disable autoreaload so wezterm doesnt keep watching changes in config file
config.automatically_reload_config = false

--Example of customization to make a gradient background
config.window_background_gradient = {
	orientation = "Vertical",
	colors = {
		--"#2A004F",
		--"#230041",
		--"#1B0034",
		"#140026",
		"#06000B",
		"#000001",
	},

	-- "Linear", "Basis" and "CatmullRom" as supported.
	-- The default is "Linear".
	interpolation = "Basis",

	-- "Rgb", "LinearRgb", "Hsv" and "Oklab" are supported.
	-- The default is "Rgb".
	blend = "Rgb",

	-- Smaller values, or 0, will make bands more prominent.
	-- The default value is 64 which gives decent looking results
	-- on a retina macbook pro display.
	noise = 64,

	-- segment_size configures how many segments are present.
	-- segment_smoothness is how hard the edge is; 0.0 is a hard edge,
	-- 1.0 is a soft edge.
	segment_size = 11,
	segment_smoothness = 1.0,
}
]]
-- --------------------------------------

-- -----------------MOUSE-----------------
--This is a script to make the mouse copy the same as Windows
--Once you select with the mouse you automatically copy to clipboard
--You paste with rightclick
config.mouse_bindings = {
	{
		event = { Down = { streak = 1, button = "Right" } },
		mods = "NONE",
		action = wezterm.action_callback(function(window, pane)
			local has_selection = window:get_selection_text_for_pane(pane) ~= ""
			if has_selection then
				window:perform_action(act.CopyTo("ClipboardAndPrimarySelection"), pane)
				window:perform_action(act.ClearSelection, pane)
			else
				window:perform_action(act({ PasteFrom = "Clipboard" }), pane)
			end
		end),
	},
}
-- --------------------------------------

-- -----------------SHORTCUTS-----------------
config.keys = {}

--Move tabs with CTRL + ALT + tab position to move (works moving current tab)
for i = 1, 8 do
	-- CTRL+ALT + number to move to that position
	table.insert(config.keys, {
		key = tostring(i),
		mods = "CTRL|ALT",
		action = wezterm.action.MoveTab(i - 1),
	})
end

--[[
-- timeout_milliseconds defaults to 1000 and can be omitted
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
	{
		key = "y",
		mods = "LEADER",
		action = wezterm.action.SplitPane({
			direction = "Left",
			command = { args = { "top" } },
			size = { Percent = 50 },
		}),
	},
	-- Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A
	{
		key = "a",
		mods = "LEADER|CTRL",
		action = wezterm.action.SendKey({ key = "a", mods = "CTRL" }),
	},
}
-- timeout_milliseconds defaults to 1000 and can be omitted
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
	{
		key = "|",
		mods = "LEADER",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	-- Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A
	{
		key = "a",
		mods = "LEADER|CTRL",
		action = wezterm.action.SendKey({ key = "a", mods = "CTRL" }),
	},
}

]]

-- -----------------KEYBINDINGS-----------------
-- Define CTRL+SPACE as the Leader combination
config.leader = { key = " ", mods = "CTRL", timeout_milliseconds = 1000 }

config.keys = {
	-- Send "CTRL-SPACE" to the terminal when pressing CTRL-SPACE, CTRL-SPACE
	{
		key = " ",
		mods = "LEADER|CTRL",
		action = wezterm.action.SendKey({ key = " ", mods = "CTRL" }),
	},

	-- Create panes
	{
		key = "|",
		mods = "LEADER",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "-",
		mods = "LEADER",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},

	-- Navigate panes
	{
		key = "h",
		mods = "CTRL",
		action = act.ActivatePaneDirection("Left"),
	},
	{
		key = "l",
		mods = "CTRL",
		action = act.ActivatePaneDirection("Right"),
	},
	{
		key = "j",
		mods = "CTRL",
		action = act.ActivatePaneDirection("Down"),
	},
	{
		key = "k",
		mods = "CTRL",
		action = act.ActivatePaneDirection("Up"),
	},

	-- Manage tabs
	{
		key = "w",
		mods = "LEADER",
		action = wezterm.action.CloseCurrentPane({ confirm = true }), --Also closes tab if there is only one pane
	},
	{
		key = "t",
		mods = "LEADER",
		action = act.SpawnTab("CurrentPaneDomain"),
	},

	{
		key = "t",
		mods = "LEADER",
		action = act.SpawnTab("CurrentPaneDomain"),
	},
	{
		key = "1",
		mods = "LEADER",
		action = act.ActivateTab(0),
	},

	{
		key = "2",
		mods = "LEADER",
		action = act.ActivateTab(1),
	},
	{
		key = "3",
		mods = "LEADER",
		action = act.ActivateTab(2),
	},
	{
		key = "4",
		mods = "LEADER",
		action = act.ActivateTab(3),
	},
	{
		key = "5",
		mods = "LEADER",
		action = act.ActivateTab(4),
	},
	{
		key = "6",
		mods = "LEADER",
		action = act.ActivateTab(5),
	},
	{
		key = "7",
		mods = "LEADER",
		action = act.ActivateTab(6),
	},
	{
		key = "8",
		mods = "LEADER",
		action = act.ActivateTab(7),
	},
	{
		key = "9",
		mods = "LEADER",
		action = act.ActivateTab(8),
	},

	-- Copy and find modes
	{
		key = "x",
		mods = "LEADER",
		action = act.ActivateCopyMode,
	},
	{
		key = "f",
		mods = "LEADER",
		action = act.Search("CurrentSelectionOrEmptyString"),
	},
}

-- --------------------------------------

return config
