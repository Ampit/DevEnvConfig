require('hs.ipc')
local focus = require('directional_focus')
for _, direction in ipairs({'left', 'down', 'up', 'right'}) do
  hs.urlevent.bind('focus-' .. direction, function() focus.focus(direction) end)
end
hs.autoLaunch(true)

commandReceiver = require('command_receiver')

pointerNavigation = require('pointer_navigation')
