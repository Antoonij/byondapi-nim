import ../byondapi_raw/byondapi

proc getVersion*(): (u4c, u4c) =
  var major, build: u4c
  Byond_GetVersion(addr major, addr build)

  (major, build)

proc getDmbVersion*(): u4c {.inline.} = 
  Byond_GetDMBVersion()
