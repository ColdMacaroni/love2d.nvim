-- Loaded using :runtime in the ftplugin
if not vim.g.love2d_loaded then
  ---Find a filepath in the runtime path
  ---@param s string
  local function get_path(s)
    return vim.fn.globpath(vim.o.runtimepath, s):gmatch("[^\n]+")()
  end

  vim.g.love2d_default_opts = {
    love_binary = "love",
    -- If there's more than one match in rtp, they're returned separated by newlines.
    -- The gmatch is there so we only get the first match.
    love_libraries = {
      love2d = get_path("love2d/library"),
      luasocket = get_path("luasocket/library"),
    },
    restart_on_save = false,
  }

  vim.g.love2d_loaded = true
end
