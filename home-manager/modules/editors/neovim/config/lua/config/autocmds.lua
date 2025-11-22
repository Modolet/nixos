vim.api.nvim_create_autocmd("FileType", {
	pattern = { "lua", "vue", "ts", "typescriptreact", "js" },
	callback = function()
		local opt = vim.opt
		opt.tabstop = 2
		opt.softtabstop = 2
		opt.shiftwidth = 2
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = function()
		local opt = vim.opt
		opt.spell = false
	end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = "*.slint",
	callback = function()
		vim.bo.filetype = "slint"
		local opt = vim.opt
		opt.tabstop = 4
		opt.softtabstop = 4
		opt.shiftwidth = 4
	end,
})

vim.api.nvim_create_autocmd("User", {
	pattern = "BlinkCmpCompletionMenuOpen",
	callback = function()
		vim.b.copilot_suggestion_hidden = true
	end,
})

vim.api.nvim_create_autocmd("User", {
	pattern = "BlinkCmpCompletionMenuClose",
	callback = function()
		vim.b.copilot_suggestion_hidden = false
	end,
})

vim.api.nvim_create_autocmd("TermOpen", {
	pattern = "*",
	callback = function()
		vim.opt_local.number = false
		vim.opt_local.relativenumber = false
	end,
})
