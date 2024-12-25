-- Loaded using :runtime in the ftplugin
if not vim.g.love2d_loaded then
  vim.g.love2d_default_opts = {
    love_binary = "love",
    -- If there's more than one match in rtp, they're returned separated by newlines.
    -- The gmatch is there so we only get the first match.
    love_library = vim.fn.globpath(vim.o.runtimepath, "love2d/library"):gmatch("[^\n]+")(),
    restart_on_save = false,
  }

  vim.g.love2d_loaded = true
end
