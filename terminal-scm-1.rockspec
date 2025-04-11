local package_name = "terminal"
local package_version = "scm"
local rockspec_revision = "1"
local github_account_name = "Tieske"
local github_repo_name = "terminal.lua"


package = package_name
version = package_version.."-"..rockspec_revision

source = {
  url = "git+https://github.com/"..github_account_name.."/"..github_repo_name..".git",
  branch = (package_version == "scm") and "main" or nil,
  tag = (package_version ~= "scm") and package_version or nil,
}

description = {
  summary = "Cross platform terminal library for Lua (Windows/Unix/Mac)",
  detailed = [[
    Cross platform terminal library for Lua (Windows/Unix/Mac)
  ]],
  license = "MIT",
  homepage = "https://github.com/"..github_account_name.."/"..github_repo_name,
}

dependencies = {
  "lua >= 5.1, < 5.5",
  "luasystem >= 0.6.0",
  "utf8",
}

build = {
  type = "builtin",

  modules = {
    ["terminal.init"] = "src/terminal/init.lua",
    ["terminal.progress"] = "src/terminal/progress.lua",
    ["terminal.sequence"] = "src/terminal/sequence.lua",
    ["terminal.input"] = "src/terminal/input.lua",
    ["terminal.output"] = "src/terminal/output.lua",
    ["terminal.clear"] = "src/terminal/clear.lua",
    ["terminal.utils"] = "src/terminal/utils.lua",
    ["terminal.scroll.init"] = "src/terminal/scroll/init.lua",
    ["terminal.scroll.stack"] = "src/terminal/scroll/stack.lua",
    ["terminal.cursor.init"] = "src/terminal/cursor/init.lua",
    ["terminal.cursor.visible.init"] = "src/terminal/cursor/visible/init.lua",
    ["terminal.cursor.visible.stack"] = "src/terminal/cursor/visible/stack.lua",
    ["terminal.cursor.shape.init"] = "src/terminal/cursor/shape/init.lua",
    ["terminal.cursor.shape.stack"] = "src/terminal/cursor/shape/stack.lua",
    ["terminal.cursor.position.init"] = "src/terminal/cursor/position/init.lua",
    ["terminal.cursor.position.stack"] = "src/terminal/cursor/position/stack.lua",
    ["terminal.draw.init"] = "src/terminal/draw/init.lua",
    ["terminal.draw.line"] = "src/terminal/draw/line.lua",
    ["terminal.text.init"] = "src/terminal/text/init.lua",
    ["terminal.text.color"] = "src/terminal/text/color.lua",
    ["terminal.text.stack"] = "src/terminal/text/stack.lua",
    ["terminal.text.width"] = "src/terminal/text/width.lua",
  },

  copy_directories = {
    -- can be accessed by `luarocks terminal doc` from the commandline
    "docs",
  },
}
