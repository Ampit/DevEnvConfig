return {
  {
    "mfussenegger/nvim-jdtls",
    opts = function(_, opts)
      vim.list_extend(opts.cmd, {
        "--java-executable",
        "/opt/homebrew/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home/bin/java",
      })
      local project_root = opts.root_dir
      opts.root_dir = function(path)
        return project_root(path) or vim.fs.dirname(vim.fs.normalize(path))
      end
      opts.settings.java.configuration = {
        runtimes = {
          {
            name = "JavaSE-17",
            path = "/opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home",
            default = true,
          },
        },
      }
    end,
  },
}
