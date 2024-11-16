local function mvn_new_project()
  -- Fungsi untuk meminta input dari pengguna
  local function get_user_input(prompt, default_value)
    vim.fn.inputsave()
    local result = vim.fn.input(prompt, default_value)
    vim.fn.inputrestore()
    return result
  end

  -- Ambil input dari pengguna untuk menentukan direktori proyek
  local project_dir = get_user_input("Enter project directory: ", vim.fn.getcwd())

  -- Buat direktori jika belum ada
  if vim.fn.isdirectory(project_dir) == 0 then
    vim.fn.mkdir(project_dir, "p")
  end

  local function create_notif(message, level)
    local notif_ok, notify = pcall(require, "notify")
    if notif_ok then
      notify(message, level)
    else
      print(message)
    end
  end

  -- Pindah ke direktori proyek
  vim.fn.chdir(project_dir)
  create_notif("Changed directory to: " .. project_dir, "info")

  -- Ambil input dari pengguna
  local group_id = get_user_input("Enter groupId: ", "com.example")
  local artifact_id = get_user_input("Enter artifactId: ", "myproject")
  local archetype_artifact_id = get_user_input("Enter archetypeArtifactId: ", "maven-archetype-quickstart")
  local archetype_version = get_user_input("Enter archetypeVersion: ", "1.4")
  local interactive_mode = get_user_input("Enter interactiveMode (true/false): ", "false")

  -- Format perintah Maven berdasarkan input pengguna
  local command = string.format(
    [[mvn archetype:generate "-DgroupId=%s" "-DartifactId=%s" "-DarchetypeArtifactId=%s" "-DarchetypeVersion=%s" "-DinteractiveMode=%s"]],
    group_id,
    artifact_id,
    archetype_artifact_id,
    archetype_version,
    interactive_mode
  )

  -- Fungsi untuk menjalankan perintah Maven dan menampilkan outputnya
  local function run_maven_command(cmd, project_name)
    local output = vim.fn.system(cmd)
    if vim.v.shell_error ~= 0 then
      print("Erro ao executar: " .. output)
    else
      local ch_dir = string.format("cd %s", project_name)
      vim.fn.system(ch_dir)
      vim.fn.chdir(project_name)
      -- Cari dan buka file main class
      local uname = vim.loop.os_uname().sysname
      if uname == "Windows_NT" then
        group_id = group_id:gsub("%.", "\\")
        local main_class_path = string.format("src\\main\\java\\%s\\App.java", group_id)
        if vim.fn.filereadable(main_class_path) == 1 then
          vim.cmd(":edit " .. main_class_path)
        end
      else
        group_id = group_id:gsub("%.", "/")
        local main_class_path = string.format("src/main/java/%s/App.java", group_id)
        if vim.fn.filereadable(main_class_path) == 1 then
          vim.cmd(":edit " .. main_class_path)
        end
      end
      vim.cmd(":NvimTreeFindFileToggl<CR>")
    end
  end

  -- Jalankan perintah Maven dan buka proyek
  run_maven_command(command, artifact_id)
  create_notif("Project created successfully !", "info")
end

vim.api.nvim_create_user_command("MavenNewProject", mvn_new_project, {})