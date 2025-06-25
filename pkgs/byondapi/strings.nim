import ../byondapi_raw/byondapi, error, value/value, ../byond_version

proc getStrId*(str: cstring): u4c = 
  result = Byond_GetStrId(str)
  
  if result == NONE:
    raise newException(ByondCallError, "Failed to get string ID")

template getStrId*(str: string): u4c = 
  getStrId(str.cstring)

proc addGetStrId*(str: cstring): u4c =
  result = Byond_AddGetStrId(str)
  
  if result == NONE:
    raise newException(ByondCallError, "Failed to add or get string ID")

template addGetStrId*(str: string): u4c =
  addGetStrId(str.cstring)
  
proc setStr*(src: var ByondValue, str: cstring) {.inline.} = 
  ByondValue_SetStr(addr src, str)

template setStr*(src: var ByondValue, str: string) = 
  setStr(src, str.cstring)

proc setStr*(src: var ByondValue, strid: u4c) {.byond(516), inline.} = 
  ByondValue_SetStrId(addr src, strid)

template strId*(src: untyped): u4c =
  var strcache {.global, gensym.}: u4c = 0

  if strcache == 0:
    strcache = getStrId(`src`)

  strcache
