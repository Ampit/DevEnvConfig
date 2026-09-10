local M = {hotkeys = {}, tasks = {}, lastCommand = nil, dryRun = false}
local bindings = assert(hs.json.read(os.getenv('HOME') .. '/.config/karabiner/command-receiver.json'))

function M.run(command)
  M.lastCommand = command
  if M.dryRun then return end
  local direction = command:match("^/usr/bin/open %-g 'hammerspoon://focus%-(%a+)'$")
  if direction then return require('directional_focus').focus(direction) end
  local task
  task = hs.task.new('/bin/sh', function(code, stdout, stderr)
    M.tasks[task] = nil
    if code ~= 0 then
      hs.printf('Shortcut failed (%d): %s\n%s', code, command, stderr)
      hs.alert.show('Shortcut failed. See Hammerspoon Console.')
    end
  end, {'-c', command})
  assert(task, 'Could not create shortcut task')
  M.tasks[task] = true
  if not task:start() then
    M.tasks[task] = nil
    hs.alert.show('Could not start shortcut task')
  end
end

function M.stop()
  for _, hotkey in ipairs(M.hotkeys) do hotkey:delete() end
  M.hotkeys = {}
end

for _, binding in ipairs(bindings) do
  assert(type(binding.command) == 'string' and type(binding.key) == 'string'
    and type(binding.receiverModifiers) == 'table', 'Invalid shortcut registry')
  if not hs.hotkey.assignable(binding.receiverModifiers, binding.key) then
    M.stop()
    error('Receiver key unavailable: ' .. binding.key)
  end
  local hotkey = hs.hotkey.bind(binding.receiverModifiers, binding.key, function() M.run(binding.command) end)
  if not hotkey then M.stop(); error('Receiver registration failed: ' .. binding.key) end
  M.hotkeys[#M.hotkeys + 1] = hotkey
end
return M
