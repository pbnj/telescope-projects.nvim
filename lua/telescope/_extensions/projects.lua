local conf = require("telescope.config").values
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")

local projects = function(opts)
  opts = opts or {}
  local projects_finder = (function()
    if vim.fn.executable("fd") == 1 then
      return { "fd", "--unrestricted", "^\\.git$", vim.fn.glob("${HOME}"), "--type", "d", "--prune", "--exec", "printf", '%s\\n',
        "{//}" }
    elseif vim.fn.executable("gfind") == 1 then
      return { "gfind", vim.fn.glob("${HOME}"), "-name", ".git", "-type", "d", "-prune", "-printf", "%h\\n" }
    else
      return { "find", vim.fn.glob("${HOME}"), "-type", "d", "-name", ".git", "-execdir", "test", "-d", ".git", "\\;", "-print",
        "-prune", "|", "xargs", "-I{}", "dirname", "{}" }
    end
  end)()
  pickers.new(opts, {
    prompt_title = "Projects",
    finder = finders.new_oneshot_job(projects_finder, opts),
    sorter = conf.generic_sorter(opts),
  }):find()
end

return require("telescope").register_extension {
  exports = { projects = projects },
}
