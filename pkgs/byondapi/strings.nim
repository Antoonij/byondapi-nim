import ../byondapi_raw/byondapi, error, value/value, ../byond_version

proc getStrId*(str: string): u4c = 
  result = Byond_GetStrId(str.cstring)
  
  if result == NONE_U4C:
    raise newException(ByondCallError, "Failed to get string ID for: '" & str & "'")

proc addGetStrId*(str: string): u4c =
  result = Byond_AddGetStrId(str.cstring)
  
  if result == NONE_U4C:
    raise newException(ByondCallError, "Failed to add or get string ID for: '" & str & "'")

proc setStr*(src: var ByondValue, str: string) = ByondValue_SetStr(addr src, str.cstring)

proc setStr*(src: var ByondValue, strid: u4c) {.byond(516).} = ByondValue_SetStrId(addr src, strid)
