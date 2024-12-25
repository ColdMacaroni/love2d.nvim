local config = {}

config.defaults = {
  path_to_love_bin = "love",
  path_to_love_library = vim.fn.globpath(vim.o.runtimepath, "love2d/library"),
  restart_on_save = false,
}

---@class options
---@field path_to_love_bin? string: The path to the Love2D executable
---@field path_to_love_library? string: The path to the Love2D library. Set to "" to disable LSP
---@field restart_on_save? boolean: Restart Love2D when a file is saved
config.options = {}

---Create auto commands for love2d:
--- - Restart on save: Restart Love2D when a file is saved.
local function create_auto_commands()
  if config.options.restart_on_save then
  end
  -- add here other auto commands ...
end

---Setup the love2d configuration.
---It must be called before running a love2d project.
---@param opts? options: config table
config.setup = function(opts)
  config.options = vim.tbl_deep_extend("force", {}, config.defaults, opts or {})
  if config.options.path_to_love_library ~= "" then
    local library_path = vim.fn.split(vim.fn.expand(config.options.path_to_love_library), "\n")[1]
    if vim.fn.isdirectory(library_path) == 0 then
      vim.notify("The library path " .. library_path .. " does not exist.", vim.log.levels.ERROR)
      return
    end
    setup_lsp(library_path)
  end
  create_auto_commands()
end

return config
