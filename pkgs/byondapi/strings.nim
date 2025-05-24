import ../byondapi_raw/byondapi, error, value/value

proc getStrId*(str: string): u4c = 
  result = Byond_GetStrId(str.cstring)
  
  if result == NONE_U4C:
    raise newException(ByondCallError, "Failed to get string ID for: '" & str & "'")

proc addGetStrId*(str: string): u4c =
  result = Byond_AddGetStrId(str.cstring)
  
  if result == NONE_U4C:
    raise newException(ByondCallError, "Failed to add or get string ID for: '" & str & "'")

proc setStr*(v: var ByondValue, str: string) = ByondValue_SetStr(addr v, str.cstring)

when BYOND_MAJOR >= 516:
  proc setStr*(v: var ByondValue, strid: u4c) = ByondValue_SetStrId(addr v, strid)
