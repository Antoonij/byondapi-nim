import ../byondapi_raw/byondapi, value/value, error, ../byond_version

when ByondVersion >= 516:
  type
      ByondPixLoc* = CByondPixLoc

  proc getPixLoc*(src {.byref.}: ByondValue): ByondPixLoc =
    result = ByondPixLoc()
    
    handleByondError(Byond_GetPixLoc(addr src, addr result))

  proc getBoundPixLoc*(src {.byref.}: ByondValue, dir: u1c): ByondPixLoc =
    result = ByondPixLoc()

    handleByondError(Byond_BoundPixLoc(addr src, dir, addr result))
