local M = {}

M.dark_color_scheme = "catppuccin-frappe"
M.light_color_scheme = "catppuccin-latte"

local function trim(s)
  return (s:gsub("^[%s\r\n]*(.-)[%s\r\n]*$", "%1"))
end

local function file_exists(path)
  local f = io.open(path, "r")
  if f then
    f:close()
  end
  return f ~= nil
end

M.set_color_scheme_from_system = function()
  local handle = io.popen("gsettings get org.gnome.desktop.interface gtk-theme")
  if not handle then
    return
  end

  local result = handle:read("*a")
  handle:close()
  result = trim(result)

  if result ~= vim.g.last_theme then
    vim.g.last_theme = result
  else
    vim.defer_fn(function()
      M.set_color_scheme_from_system()
    end, 1000)
    return
  end

  local colorschemes = {
    ["'Catppuccin-Mocha'"] = "catppuccin-mocha",
    ["'Catppuccin-Latte'"] = "catppuccin-latte",
    ["'Decay-Green'"] = "decay",
    ["'Rose-Pine'"] = "rose-pine-main",
    ["'Tokyo-Night'"] = "tokyonight-night",
    ["'Material-Sakura'"] = "material-lighter",
    ["'Graphite-Mono'"] = "material-darker",
    ["'Cyberpunk-Edge'"] = "silverhand",
    ["'Frosted-Glass'"] = "tokyonight-day",
    ["'Gruvbox-Retro'"] = "gruvbox",
    ["'Synth-Wave'"] = "synthwave84",
    ["'One-Dark'"] = "onedark",
  }

  local scheme = colorschemes[result]
  if scheme then
    vim.cmd("colorscheme " .. scheme)
  end

  vim.defer_fn(function()
    M.set_color_scheme_from_system()
  end, 1000)
end

return M
