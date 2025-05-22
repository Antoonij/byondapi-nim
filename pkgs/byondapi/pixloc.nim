import ../byondapi_raw/byondapi, value/value

when BYOND_MAJOR < 516:
  static:
    error "This file is only compatible with BYOND version 516+"

type
    ByondPixLoc* = CByondPixLoc

proc getPixLoc*(src {.byref.}: ByondValue): ByondPixLoc =
  result = ByondPixLoc()
  discard Byond_GetPixLoc(addr src, addr result)

proc getBoundPixLoc*(src {.byref.}: ByondValue, dir: u1c): ByondPixLoc =
  result = ByondPixLoc()
  discard Byond_BoundPixLoc(addr src, dir, addr result)
