local M = {}

M.toggle_relativenumber = function()
  local number = vim.wo.number
  local relativenumber = vim.wo.relativenumber

  if number and relativenumber then
    vim.wo.relativenumber = false
  elseif number and not relativenumber then
    vim.wo.relativenumber = true
  else
    vim.wo.number = true
    vim.wo.relativenumber = true
  end
end

return M
