local timers, bindings, inputCallback = {}, {}
local visible = false
hs = {
 settings={get=function() return true end,set=function() end},
 json={read=function() return {root={title='Root',subtitle='',items={}},o={title='Apps',subtitle='',items={}}} end},
 window={focusedWindow=function() return nil end},
 mouse={getCurrentScreen=function() return {frame=function() return {x=0,y=0,w=1000,h=800} end} end},
 timer={doAfter=function(_,fn) local t={callback=fn,stopped=false};function t:stop() self.stopped=true end; timers[#timers+1]=t;return t end},
 canvas={new=function() local c={};for _,k in ipairs({'level','behavior','canvasMouseEvents','frame','replaceElements','alpha'}) do c[k]=function(self) return self end end;c.isShowing=function() return visible end;c.show=function() visible=true end;c.hide=function() visible=false end;c.delete=function() visible=false end;return c end},
 urlevent={bind=function(k,fn) bindings[k]=fn end},
 alert={show=function() end},
 eventtap={event={types={keyDown=1,leftMouseDown=2,rightMouseDown=3,otherMouseDown=4}},new=function(_,fn) inputCallback=fn;return {start=function(self) return self end,stop=function() end} end},
}
local function flush() local old=timers;timers={};for _,t in ipairs(old) do if not t.stopped then t.callback() end end end
local m=dofile(arg[1])
m.event('root','down');flush();assert(visible,'hold must show guide')
-- Reproduce the captured held=true / visible=true state when release delivery is lost.
if inputCallback then inputCallback({getType=function() return 1 end}) end
flush();assert(not visible,'guide remained visible after completing a shortcut with a missed release')
m.event('o','up');flush();assert(not visible,'late layer release must not reopen a dismissed guide')
m.event('root','up');m.event('root','down');flush();assert(visible,'next hold must show guide again')
m.event('root','up');flush();assert(not visible,'normal release must dismiss')
m.event('root','down');if inputCallback then inputCallback({getType=function() return 2 end}) end;flush();assert(not visible,'click must cancel pending guide')
m.stop()
print('Hyper Guide dismissal regression checks passed')
