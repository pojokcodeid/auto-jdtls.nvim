# auto-jdtls.nvim

- auto-jdtls.nvim is an automatic configuration for nvim-jdtls

# Instalation

- Lazy

```lua
{
"mfussenegger/nvim-jdtls",
dependencies = {
  "williamboman/mason.nvim",
  "pojokcodeid/auto-jdtls.nvim",
  "rcarriga/nvim-notify",
},
ft = { "java" },
-- your opts go here
opts = {},
-- stylua: ignore
config = function(_, opts)
  require("auto-jdtls").setup(opts)
  -- add LSP keymaps
  vim.keymap.set({ "n", "v" }, "<leader>l", "", { desc = "LSP" })
  -- Set vim motion for <Space> + l + h to show code documentation about the code the cursor is currently over if available
  vim.keymap.set("n", "<leader>lh", vim.lsp.buf.hover, { desc = "Code Hover Documentation" })
  -- Set vim motion for <Space> + l + d to go where the code/variable under the cursor was defined
  vim.keymap.set("n", "<leader>ld", vim.lsp.buf.definition, { desc = "Code Goto Definition" })
  -- Set vim motion for <Space> + l + a for display code action suggestions for code diagnostics in both normal and visual mode
  vim.keymap.set({ "n", "v" }, "<leader>la", vim.lsp.buf.code_action, { desc = "Code Actions" })
  -- Set vim motion for <Space> + l + r to display references to the code under the cursor
  vim.keymap.set("n", "<leader>lr", require("telescope.builtin").lsp_references, { desc = "Code Goto References" })
  -- Set vim motion for <Space> + l + i to display implementations to the code under the cursor
  vim.keymap.set("n", "<leader>li", require("telescope.builtin").lsp_implementations, { desc = "Code Goto Implementations" })
  -- Set a vim motion for <Space> + l + <Shift>R to smartly rename the code under the cursor
  vim.keymap.set("n", "<leader>lR", vim.lsp.buf.rename, { desc = "Code Rename" })
  -- Set a vim motion for <Space> + l + <Shift>D to go to where the code/object was declared in the project (class file)
  vim.keymap.set("n", "<leader>lD", vim.lsp.buf.declaration, { desc = "Code Goto Declaration" })
  -- add keymaps JDTLS
  vim.keymap.set('n', '<leader>J', "", { desc = "Java" })
  -- Set a Vim motion to <Space> + <Shift>J + o to organize imports in normal mode
  vim.keymap.set('n', '<leader>Jo', "<Cmd> lua require('jdtls').organize_imports()<CR>", { desc = "Java Organize Imports" })
  -- Set a Vim motion to <Space> + <Shift>J + v to extract the code under the cursor to a variable
  vim.keymap.set('n', '<leader>Jv', "<Cmd> lua require('jdtls').extract_variable()<CR>", { desc = "Java Extract Variable" })
  -- Set a Vim motion to <Space> + <Shift>J + v to extract the code selected in visual mode to a variable
  vim.keymap.set('v', '<leader>Jv', "<Esc><Cmd> lua require('jdtls').extract_variable(true)<CR>", { desc = "Java Extract Variable" })
  -- Set a Vim motion to <Space> + <Shift>J + <Shift>C to extract the code under the cursor to a static variable
  vim.keymap.set('n', '<leader>JC', "<Cmd> lua require('jdtls').extract_constant()<CR>", { desc = "Java Extract Constant" })
  -- Set a Vim motion to <Space> + <Shift>J + <Shift>C to extract the code selected in visual mode to a static variable
  vim.keymap.set('v', '<leader>JC', "<Esc><Cmd> lua require('jdtls').extract_constant(true)<CR>", { desc = "Java Extract Constant" })
  -- Set a Vim motion to <Space> + <Shift>J + t to run the test method currently under the cursor
  vim.keymap.set('n', '<leader>Jt', "<Cmd> lua require('jdtls').test_nearest_method()<CR>", { desc = "Java Test Method" })
  -- Set a Vim motion to <Space> + <Shift>J + t to run the test method that is currently selected in visual mode
  vim.keymap.set('v', '<leader>Jt', "<Esc><Cmd> lua require('jdtls').test_nearest_method(true)<CR>", { desc = "Java Test Method" })
  -- Set a Vim motion to <Space> + <Shift>J + <Shift>T to run an entire test suite (class)
  vim.keymap.set('n', '<leader>JT', "<Cmd> lua require('jdtls').test_class()<CR>", { desc = "Java Test Class" })
  -- Set a Vim motion to <Space> + <Shift>J + u to update the project configuration
  vim.keymap.set('n', '<leader>Ju', "<Cmd> JdtUpdateConfig<CR>", { desc = "Java Update Config" })
end,
},
```

default opts :

```lua
{
  root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }),
  project_name = function()
    return vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
  end,

  -- Where are the config and workspace dirs for a project?
  jdtls_config_dir = function(project_name)
    return vim.fn.stdpath("cache") .. "/jdtls/" .. project_name .. "/config"
  end,
  jdtls_workspace_dir = function(project_name)
    return vim.fn.stdpath("cache") .. "/jdtls/" .. project_name .. "/workspace"
  end,
  cmd = { vim.fn.exepath("jdtls") },
  full_cmd = function(opts)
    local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
    local cmd = vim.deepcopy(opts.cmd)
    if project_name then
      vim.list_extend(cmd, {
        "-configuration",
        opts.jdtls_config_dir(project_name),
        "-data",
        opts.jdtls_workspace_dir(project_name),
      })
    end
    return cmd
  end,

  -- These depend on nvim-dap, but can additionally be disabled by setting false here.
  dap = { hotcodereplace = "auto", config_overrides = {} },
  dap_main = {},
  test = true,
  settings = {
    java = {
      inlayHints = {
        parameterNames = {
          enabled = "all",
        },
      },
    },
  },
}
```
