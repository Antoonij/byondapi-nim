import ../byondapi_raw/byondapi, error, value/value

type
    ByondPixLoc* = CByondPixLoc

proc getPixLoc*(src: ByondValue): ByondPixLoc =
  var res: ByondPixLoc
  discard Byond_GetPixLoc(addr src, addr res)

  return res

proc getBoundPixLoc*(src: ByondValue, dir: u1c): ByondPixLoc =
  var res: ByondPixLoc
  discard Byond_BoundPixLoc(addr src, dir, addr res)

  return res
