import ../byondapi_raw/byondapi

proc getVersion*(): (u4c, u4c) =
  var major, build: u4c
  Byond_GetVersion(major, build)

  return (major, build)

proc getDmbVersion*(): u4c = Byond_GetDMBVersion()
