local M = {}
local path = os.getenv('HOME') .. '/.config/local/apps.json'
local overrides = {}
if hs.fs.attributes(path) then
  overrides = assert(hs.json.read(path), 'Invalid JSON in ' .. path)
  assert(type(overrides) == 'table', 'App overrides must be an object')
  for app, replacement in pairs(overrides) do
    assert(type(app) == 'string' and app ~= '', 'App override keys must be app names')
    assert(replacement == false or (type(replacement) == 'string' and replacement ~= ''
      and not replacement:find('[%c/]')), 'App overrides must be false or an app name')
  end
end

function M.resolve(app)
  if overrides[app] == nil then return app end
  return overrides[app]
end

function M.command(command)
  local app = command:match("^open %-a '(.-)%.app'$")
  if not app then return command end
  local replacement = M.resolve(app)
  if replacement == false then return nil end
  if replacement == app then return command end
  return "open -a '" .. replacement:gsub("'", "'\\''") .. ".app'"
end

function M.menuItems(items)
  local result = {}
  for _, item in ipairs(items) do
    local app = item.app and M.resolve(item.app)
    if app ~= false then
      local copy = {}
      for key, value in pairs(item) do copy[key] = value end
      if item.app then copy.app = app; copy.label = app end
      table.insert(result, copy)
    end
  end
  return result
end

return M
