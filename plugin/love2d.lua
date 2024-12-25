vim.g.love2d_default_opts = {
  love_binary = "love",
  -- If there's more than one match in rtp, they're returned separated by newlines.
  -- The gmatch is there so we only get the first match.
  love_library = vim.fn.globpath(vim.o.runtimepath, "love2d/library"):gmatch("[^\n]+")(),
  restart_on_save = false,
}

-- Ensure this is a table to avoid problems later
vim.g.love2d_opts = vim.g.love2d_opts or {}

vim.api.nvim_create_user_command("LoveRun", function(args)
  local love2d = require("love2d")
  local path = love2d.find_src_path(args.args)
  if path then
    love2d.run(path)
  else
    vim.notify("No main.lua file found", vim.log.levels.ERROR)
  end
end, { nargs = "?", complete = "dir" })

vim.api.nvim_create_user_command("LoveStop", function()
  local love2d = require("love2d")
  love2d.stop()
end, {})
