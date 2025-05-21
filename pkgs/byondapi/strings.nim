import ../byondapi_raw/byondapi, error, value/value

proc getStrId*(str: string): u4c = 
  let id = Byond_GetStrId(str.cstring)
  
  if id == NONE_U4C:
    raise newException(ByondCallError, "Failed to get string ID for: '" & str & "'")

  return id

proc addGetStrId*(str: string): u4c =
  let id = Byond_AddGetStrId(str.cstring)
  
  if id == NONE_U4C:
    raise newException(ByondCallError, "Failed to add or get string ID for: '" & str & "'")

  return id

proc setStr*(v: var ByondValue, str: string) = ByondValue_SetStr(addr v, str.cstring)

when BYOND_MAJOR >= 516:
  proc setStr*(v: var ByondValue, strid: u4c) = ByondValue_SetStrId(addr v, strid)
