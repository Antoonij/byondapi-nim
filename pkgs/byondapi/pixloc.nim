import ../byondapi_raw/byondapi, value/value, error, ../byond_version

type
    ByondPixLoc* = CByondPixLoc 

proc getPixLoc*(src {.byref.}: ByondValue): ByondPixLoc {.byond(516).} =
  result = ByondPixLoc()
    
  handleByondError(Byond_GetPixLoc(addr src, addr result))

proc getBoundPixLoc*(src {.byref.}: ByondValue, dir: u1c): ByondPixLoc {.byond(516).} =
  result = ByondPixLoc()

  handleByondError(Byond_BoundPixLoc(addr src, dir, addr result))
