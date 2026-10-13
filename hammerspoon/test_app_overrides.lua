local directory = assert(arg[1], 'Pass the Hammerspoon source directory')
local configured
hs = {fs={attributes=function() return configured ~= nil end},
  json={read=function() return configured end}}
local function load(value)
  configured=value
  return dofile(directory .. '/app_overrides.lua')
end
local command="open -a 'IntelliJ IDEA OSS.app'"
local defaults=load(nil)
assert(defaults.command(command)==command)
local items={{key='v',app='IntelliJ IDEA OSS',label='IntelliJ IDEA OSS'},
  {key='h',app='Google Chrome',label='Google Chrome'},{key='w',label='Window studio',group=true}}
local disabled=load({['IntelliJ IDEA OSS']=false})
assert(disabled.command(command)==nil)
assert(disabled.command('some non-app action')=='some non-app action')
local menu=disabled.menuItems(items)
assert(#menu==2 and menu[1].key=='h' and menu[2].group)
assert(#items==3 and items[1].label=='IntelliJ IDEA OSS')
local replacement=load({['IntelliJ IDEA OSS']='Cursor'})
assert(replacement.command(command)=="open -a 'Cursor.app'")
assert(replacement.menuItems(items)[1].app=='Cursor')
assert(replacement.menuItems(items)[1].label=='Cursor')
assert(load({['IntelliJ IDEA OSS']="Amar's Editor"}).command(command)=="open -a 'Amar'\\''s Editor.app'")
assert(not pcall(load,{['IntelliJ IDEA OSS']=true}))
assert(not pcall(load,{['IntelliJ IDEA OSS']='bad\nname'}))
-- A disabled app must return before touching the pointer helper or spawning a task.
package.loaded.app_overrides=disabled
hs.json.read=function() return {} end
local receiver=dofile(directory .. '/command_receiver.lua')
receiver.run(command)
assert(receiver.lastCommand==nil and next(receiver.tasks)==nil)
print('App override checks passed: defaults, disable, replacement, menu, validation, receiver')
