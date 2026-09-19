from pathlib import Path
import json, re, copy
root=Path(__file__).resolve().parent
config=root/'karabiner.json'
raw=config.read_text()
assert 'hammerspoon://hyper-guide?' not in raw, 'Build rules.ts before generating Hyper Guide'
data=json.loads(raw)
menus={'root':{'title':'Your next move','subtitle':'One key away.','items':[]}}
titles={'o':'Daily apps','i':'More apps','w':'Window studio','b':'On the web','s':'System controls','v':'Navigation','c':'Now playing','r':'Raycast tools','d':'Precise pointer','f':'Fast pointer'}
labels={'spacebar':'Pomodoro','h':'Pointer left','j':'Pointer down','k':'Pointer up','l':'Pointer right','e':'Left click','t':'Right click'}
friendly={'volume_increment':'Volume up','volume_decrement':'Volume down','display_brightness_increment':'Brightness up','display_brightness_decrement':'Brightness down','play_or_pause':'Play / pause','fastforward':'Next track','rewind':'Previous track','left_arrow':'Left','right_arrow':'Right','up_arrow':'Up','down_arrow':'Down','page_down':'Page down','page_up':'Page up'}
def hook(key,state):return {'shell_command':f"/usr/bin/open -g 'hammerspoon://hyper-guide?key={key}&state={state}'"}
def name(m,layer):
 d=m.get('description','')
 # Descriptions survive command routing, so app labels remain source-derived.
 if d:
  d=re.sub(r'^(Open|Window|Raycast):?\s*','',d)
  d=re.sub(r"^open -a ['\"]?",'',d);d=d.removesuffix(".app'")
  d=re.sub(r"^-a ['\"]?",'',d)
  if '://' not in d:return d.replace('-',' ').capitalize() if layer=='w' else d
  tail=d.rstrip("'\"").split('/')[-1]
  return tail.replace('-',' ').capitalize()
 t=m.get('to',[{}])[0]
 if 'mouse_key' in t:
  mouse=t['mouse_key']
  if 'vertical_wheel' in mouse:return 'Scroll '+('down' if mouse['vertical_wheel']>0 else 'up')
  return 'Pointer '+({'h':'left','j':'down','k':'up','l':'right'}[m['from']['key_code']])
 k=m['from']['key_code']
 if layer=='w' and k=='x':return 'Quit app'
 if layer=='s' and k=='l':return 'Lock screen'
 return friendly.get(t.get('key_code'),t.get('key_code',k).replace('_',' ').capitalize())
for rule in data['profiles'][0]['complex_modifications']['rules']:
 for m in rule.get('manipulators',[]):
  variable=next((t['set_variable']['name'] for t in m.get('to',[]) if 'set_variable' in t and t['set_variable']['value']==1),None)
  if variable=='hyper' or (variable and variable.startswith('hyper_sublayer_')):
   key='root' if variable=='hyper' else variable.removeprefix('hyper_sublayer_')
   m['to'].append(hook(key,'down'));m.setdefault('to_after_key_up',[]).append(hook(key,'up'))
   if key!='root':
    menus[key]={'title':titles[key],'subtitle':'Keep Hyper held. Choose your next key.','items':[]}
    menus['root']['items'].append({'key':key,'label':titles[key],'group':True})
  elif any(c.get('type')=='variable_if' and c.get('name')=='hyper' and c.get('value')==1 for c in m.get('conditions',[])):
   k=m['from'].get('key_code')
   if k in labels:menus['root']['items'].append({'key':k,'label':labels[k]})
  else:
   layer=next((str(c['name']).removeprefix('hyper_sublayer_') for c in m.get('conditions',[]) if str(c.get('name','')).startswith('hyper_sublayer_') and c.get('value')==1),None)
   if layer in menus:menus[layer]['items'].append({'key':m['from']['key_code'],'label':name(m,layer),**({'app':name(m,layer)} if layer in ['o','i'] else {})})
rules=data['profiles'][0]['complex_modifications']['rules']
assert not any(m.get('from',{}).get('key_code')=='slash' for r in rules for m in r.get('manipulators',[])), 'Slash is already mapped; check conflicts before installing toggle'
root_command=next(m for r in rules for m in r.get('manipulators',[]) if m.get('from',{}).get('key_code')=='e' and any(c.get('name')=='hyper' and c.get('value')==1 for c in m.get('conditions',[])))
rules.append({'description':'Hyper Guide: toggle hints','manipulators':[{
 'type':'basic','from':{'key_code':'slash','modifiers':{'optional':['any']}},
 'conditions':copy.deepcopy(root_command['conditions']),
 'to':[], 'to_after_key_up':[{'shell_command':"/usr/bin/open -g 'hammerspoon://hyper-guide-toggle'"}]
}]})
menus['root']['items'].append({'key':'slash','label':'Toggle Hyper Guide'})
menus['root']['items'].sort(key=lambda i:(not i.get('group',False),i['key']))
(root/'hyper-guide-menu.json').write_text(json.dumps(menus,indent=2))
new=json.dumps(data,indent=2)
config.write_text(new)
print({k:len(v['items']) for k,v in menus.items()})
