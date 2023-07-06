local wezterm = require 'wezterm'
local config = {}

config.default_domain = 'WSL:bullseye'
config.window_decorations = 'INTEGRATED_BUTTONS|RESIZE'
-- config.initial_rows = 50
-- config.initial_cols = 150
config.initial_rows = 24
config.initial_cols = 80
config.use_fancy_tab_bar = true
config.font = wezterm.font('VictorMono NF')
config.font_rules = {
	{
		intensity = 'Normal',
		italic = false,
		font = wezterm.font {
			family = 'VictorMono NF',
			weight = 'Regular',
		},
	},
	{
		intensity = 'Bold',
		italic = false,
		font = wezterm.font {
			family = 'VictorMono NF',
			weight = 'Regular',
		},
	},
	{
		intensity = 'Half',
		italic = false,
		font = wezterm.font {
			family = 'VictorMono NF',
			weight = 'Regular',
		},
	},
	{
		intensity = 'Normal',
		italic = true,
		font = wezterm.font {
			family = 'VictorMono NF',
			weight = 'Light',
			style = 'Italic',
		},
	},
	{
		intensity = 'Bold',
		italic = true,
		font = wezterm.font {
			family = 'VictorMono NF',
			weight = 'Medium',
			style = 'Italic',
		},
	},
	{
		intensity = 'Half',
		italic = true,
		font = wezterm.font {
			family = 'VictorMono NF',
			weight = 'Light',
			style = 'Italic',
		},
	},
}
config.font_size = 13
config.line_height = 1.00
config.bold_brightens_ansi_colors = "No"
config.treat_east_asian_ambiguous_width_as_wide = false
config.unicode_version = 9
-- config.normalize_output_to_unicode_nfc = true
-- config.allow_square_glyphs_to_overflow_width = "Always"
config.allow_square_glyphs_to_overflow_width = "Never"
-- this is needed because otherwise box drawing characters can overlap
-- e.g. when displaying a tree which causes brightness variations
config.custom_block_glyphs = true
config.freetype_load_target = "Light"
config.freetype_render_target = "Light"
config.color_scheme = 'Gruvbox dark, hard (base16)'
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

return config
