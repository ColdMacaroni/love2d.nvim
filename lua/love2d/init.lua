local love2d = {}

---@class job
---@field id number: job-id returned by vim.fn.jobstart
---@field exit_code number: exit-code intercepted by on_exit callback

---Find a valid path to the Love2D project
---@param path string: The path to the Love2D project. If "" search for it.
---@return string?: The path to the Love2D project. nil if not found
love2d.find_src_path = function(path)
  local main
  if path == "" then
    main = vim.fn.findfile("main.lua", ".;")
  else
    main = vim.fn.findfile("main.lua", path)
  end
  if main == "" then
    return
  end
  return vim.fn.fnamemodify(main, ":h")
end

---Run a Love2D project
---@param path string?: The path to the Love2D project. Nil to search.
love2d.run = function(path)
  path = path or love2d.find_src_path("")

  if not path then
    vim.notify("No main.lua file found", vim.log.levels.ERROR)
    return
  end

  if love2d.job and love2d.job.id then
    vim.notify("A LÖVE project is already running.", vim.log.levels.WARN)
    return
  end
  love2d.job = {} -- reset job
  vim.notify("Running LÖVE project at " .. path)
  vim.cmd [[ runtime plugin/love2d.lua ]]
  local cmd = {
    (type(vim.g.love2d_opts) == "table" and vim.g.love2d_opts.love_binary) or vim.g.love2d_default_opts.love_binary,
    path
  }

  love2d.job.id = vim.fn.jobstart(cmd, {
    on_exit = function(_, code)
      love2d.job.exit_code = code
      love2d.job.id = nil
    end,
  })
end

---Stop the running project
love2d.stop = function()
  if not love2d.job or not love2d.job.id then
    vim.notify("No LÖVE project running.", vim.log.levels.WARN)
    return
  end
  vim.notify("Stopped LÖVE project")
  vim.fn.jobstop(love2d.job.id)
end

return love2d
