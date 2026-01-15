local opt = vim.opt

opt.tabstop = 4
opt.expandtab = true
opt.softtabstop = 4
opt.shiftwidth = 4
opt.swapfile = false
opt.spell = false

vim.g.ai_cmp = false

if vim.g.neovide then
	vim.o.guifont = "Maple Mono NF CN:h12"
	vim.g.neovide_window_blurred = true
	vim.g.neovide_floating_shadow = true
	vim.g.neovide_floating_z_height = 10
	vim.g.neovide_light_angle_degrees = 45
	vim.g.neovide_light_radius = 5
	vim.g.neovide_cursor_vfx_mode = "railgun"
	vim.g.neovide_fullscreen = false
	vim.g.snacks_animate = false
else
end
