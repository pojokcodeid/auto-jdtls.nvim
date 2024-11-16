local M = {}

M.setup = function(opt)
  opt = opt or {}
  require("auto-jdtls.create_maven_project")
  if vim.bo.filetype == "java" then
    require("auto-jdtls.utils").install()
    require("auto-jdtls.utils").attach_jdtls(opt)
  end
end

return M
