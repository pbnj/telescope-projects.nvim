local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values

local projects_finder = {}
if vim.fn.executable("fd") > 0 then
  projects_finder = { "fd", "--unrestricted", "^\\.git$", "${HOME}", "--type", "d", "--prune", "--exec", "printf",
    '%s\\n', "{//}" }
elseif vim.fn.executable("gfind") > 0 then
  projects_finder = { "gfind", "${HOME}", "-name", ".git", "-type", "d", "-prune", "-printf", "%h\\n" }
else
  projects_finder = { "find", "${HOME}", "-type", "d", "-name", ".git", "-execdir", "test", "-d", ".git", "\\;",
    "-print", "-prune", "|", "xargs", "-I{}", "dirname", "{}", }
end

local projects = function(opts)
  opts = opts or {}
  pickers.new(opts, {
    prompt_title = "colors",
    finder = finders.new_oneshot_job(projects_finder, opts),
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        if vim.fn.exists("$TMUX") then
          local cmd = string.format("tmux new-window -c %s -- nvim || vim.", selection[1])
          vim.fn.system(cmd)
        elseif vim.fn.exists("g:neovide") then
          vim.cmd.tabnew(selection[1])
        else
          vim.cmd.edit(selection[1])
        end
      end)
      return true
    end,
  }):find()
end

return require("telescope").register_extension {
  exports = { projects = projects },
}
