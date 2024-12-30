vim.cmd.runtime("plugin/love2d.lua")

-- Ensure this is a table to avoid problems later
if type(vim.g.love2d_opts) ~= "table" then
  vim.g.love2d_opts = {}
end

-- Enable LSP settings if in a love 2d project
-- Usually in vimscript people use 0 as "false", but that's a truthy value in lua.
local buf_path = vim.fn.expand("%:h")
local path = require("love2d").find_src_path(buf_path)
if not vim.g.love2d_is_project and vim.g.love2d_is_project ~= 0 then
  if not path then
    return
  end
end

-- We only need to set this up once, hence the guard variable.
if not vim.g.love2d_lsp_configured then
  local lspconfig_installed, lspconfig = pcall(require, "lspconfig")
  if lspconfig_installed then
    ---Gets the named library from either user opts or default opts
    ---@param l string
    local function lib(l)
      local usr = vim.g.love2d_opts.love_libraries
      local default = vim.g.love2d_default_opts.love_libraries
      return (usr and usr[l]) or default[l]
    end

    local libraries = {
      lib("love2d"),
      lib("luasocket"),
      vim.fn.fnamemodify(path, ":p"),
    }

    for _, p in ipairs(libraries) do
      if vim.fn.isdirectory(p) == 0 then
        vim.notify("The library path " .. p .. " does not exist.", vim.log.levels.ERROR)
        return
      end
    end

    lspconfig.lua_ls.setup({
      settings = {
        Lua = {
          workspace = {
            library = libraries,
          },
        },
      },
    })
  else
    vim.notify("lspconfig is not present. Will not attempt to set up lua_ls library path.", vim.log.levels.WARN)
  end

  vim.g.love2d_lsp_configured = true
end

vim.api.nvim_create_autocmd("BufWritePost", {
  group = vim.api.nvim_create_augroup("love2d_restart_on_save", { clear = true }),
  pattern = { "*.lua" },
  callback = function()
    if vim.g.love2d_opts.restart_on_save then
      local love2d = require("love2d")
      love2d.stop()
      vim.defer_fn(function()
        love2d.run(path)
      end, 500)
    end
  end,
})
