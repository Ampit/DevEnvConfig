local linux = vim.uv.os_uname().sysname == "Linux"
return {
  {
    "mfussenegger/nvim-jdtls",
    opts = function(_, opts)
      vim.list_extend(opts.cmd, {
        "--java-executable",
        linux and "/usr/lib/jvm/java-21-openjdk-arm64/bin/java" or "/opt/homebrew/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home/bin/java",
      })
      local project_root = opts.root_dir
      opts.root_dir = function(path)
        return project_root(path) or vim.fs.dirname(vim.fs.normalize(path))
      end
      opts.settings.java.configuration = {
        runtimes = {
          {
            name = "JavaSE-17",
            path = linux and "/usr/lib/jvm/java-17-openjdk-arm64" or "/opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home",
            default = true,
          },
        },
      }
    end,
  },
}
