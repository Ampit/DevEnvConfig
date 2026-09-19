local M = {held = false, layer = nil, enabled = hs.settings.get('hyperGuideEnabled') ~= false}
local menus = assert(hs.json.read(os.getenv('HOME') .. '/.config/karabiner/hyper-guide-menu.json'))
local canvas, pending
local icons = {}
local ink = {hex='#F2F3FA'}
local muted = {hex='#969BAE'}
local accent = {hex='#B9ACFF'}
local function rect(x,y,w,h,color,radius)
  return {type='rectangle', action='fill', frame={x=x,y=y,w=w,h=h}, fillColor=color, roundedRectRadii={xRadius=radius or 0,yRadius=radius or 0}}
end
local function text(value,x,y,w,size,color,font)
  return {type='text',text=value,frame={x=x,y=y,w=w,h=size*1.7},textSize=size,textColor=color or ink,textFont=font or '.AppleSystemUIFont',textLineBreak='truncateTail'}
end
function M.hide()
  if pending then pending:stop();pending=nil end
  if canvas then canvas:hide(0.12) end
end
function M.show(key)
  if not M.enabled then return end
  local menu = menus[key]
  if not menu then return end
  local win=hs.window.focusedWindow()
  local screen=win and win:screen() or hs.mouse.getCurrentScreen()
  local sf=screen:frame()
  local width=math.min(840,sf.w-64)
  local cols=width>=720 and 3 or 2
  local rows=math.ceil(#menu.items/cols)
  local height=162+rows*48
  local frame={x=sf.x+(sf.w-width)/2,y=sf.y+math.max(20,(sf.h-height)*0.76),w=width,h=height}
  local wasVisible=canvas and canvas:isShowing()
  if not canvas then
    canvas=hs.canvas.new(frame):level('overlay'):behavior({'canJoinAllSpaces','fullScreenAuxiliary','ignoresCycle'})
    canvas:canvasMouseEvents(false,false,false,false)
  else canvas:frame(frame) end
  local elements={
    rect(0,0,width,height,{hex='#10131D',alpha=0.97},22),
    {type='rectangle',action='stroke',frame={x=0.5,y=0.5,w=width-1,h=height-1},strokeColor={hex='#85839F',alpha=0.32},strokeWidth=1,roundedRectRadii={xRadius=22,yRadius=22}},
    rect(28,26,4,38,accent,2),
    text('H Y P E R   G U I D E',44,22,240,10,accent,'.AppleSystemUIFont'),
    text(menu.title,44,39,width-230,24,ink,'.AppleSystemUIFont'),
    rect(width-148,29,120,30,{hex='#292638'},9),
    text(key=='root' and 'CAPS  /  HOLD' or 'CAPS  ›  '..key:upper(),width-136,36,104,11,accent,'Menlo'),
    text(menu.subtitle,28,83,width-56,12,muted),
    rect(28,112,width-56,1,{hex='#FFFFFF',alpha=0.075})
  }
  local colWidth=(width-56)/cols
  for index,item in ipairs(menu.items) do
    local col=math.floor((index-1)/rows)
    local row=(index-1)%rows
    local x,y=28+col*colWidth,128+row*48
    local keyLabel=({spacebar='SPC',semicolon=';',slash='/'})[item.key] or item.key:upper()
    table.insert(elements,rect(x,y,34,30,{hex='#242837'},7))
    table.insert(elements,{type='rectangle',action='stroke',frame={x=x+0.5,y=y+0.5,w=33,h=29},strokeColor={hex='#FFFFFF',alpha=0.10},strokeWidth=1,roundedRectRadii={xRadius=7,yRadius=7}})
    table.insert(elements,text(keyLabel,x+(#keyLabel>1 and 4 or 12),y+6,30,#keyLabel>1 and 10 or 13,accent,'Menlo'))
    local labelX=x+47
    if item.app then
      if icons[item.app]==nil then
        local info=hs.application.infoForBundlePath('/Applications/'..item.app..'.app')
        icons[item.app]=info and hs.image.imageFromAppBundle(info.CFBundleIdentifier) or false
      end
      if icons[item.app] then
        table.insert(elements,{type='image',image=icons[item.app],frame={x=labelX,y=y+3,w=24,h=24},imageScaling='scaleProportionally'})
        labelX=labelX+31
      end
    end
    table.insert(elements,text(item.label,labelX,y+6,x+colWidth-labelX-16,13,ink))
    if item.group then table.insert(elements,text('›',x+colWidth-21,y+3,14,18,muted)) end
  end
  table.insert(elements,text('RELEASE CAPS TO DISMISS',28,height-25,300,9,muted,'Menlo'))
  table.insert(elements,text(string.format('%02d  /  AVAILABLE',#menu.items),width-164,height-25,140,9,muted,'Menlo'))
  canvas:replaceElements(table.unpack(elements))
  if not wasVisible then canvas:show(0.12) end
  M.current=key
end
function M.event(key,state)
  if key=='root' then
    M.held=state=='down'
    if not M.held then M.layer=nil;M.hide();return end
  else
    if state=='down' then M.layer=key elseif M.layer==key then M.layer=nil end
  end
  if not M.held or not M.enabled then return end
  if pending then pending:stop() end
  pending=hs.timer.doAfter(canvas and canvas:isShowing() and 0.02 or 0.50,function()
    pending=nil
    if M.held then M.show(M.layer or 'root') end
  end)
end
function M.toggle()
  M.enabled=not M.enabled
  hs.settings.set('hyperGuideEnabled',M.enabled)
  M.hide()
  hs.alert.show('Hyper Guide ' .. (M.enabled and 'on' or 'off'), 1)
  return M.enabled
end
function M.stop()
  M.held=false;M.hide()
  if canvas then canvas:delete();canvas=nil end
  hs.urlevent.bind('hyper-guide',nil)
  hs.urlevent.bind('hyper-guide-toggle',nil)
end
function M.snapshot(path)
  if canvas then canvas:imageFromCanvas():saveToFile(path) end
end
hs.urlevent.bind('hyper-guide',function(_,params) M.event(params.key,params.state) end)
hs.urlevent.bind('hyper-guide-toggle',function() M.toggle() end)
return M
