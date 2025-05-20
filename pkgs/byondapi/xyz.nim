import ../byondapi_raw/byondapi, error, value/[value, constructor]

type
    ByondXYZ* = CByondXYZ

proc getBlock*(corner1, corner2: ByondXYZ): seq[ByondValue] =
  var len: u4c = 0
  let success = Byond_Block(addr corner1, addr corner2, nil, len)

  if not success:
    raise newException(ByondCallError, "Failed to get block contents (initial size query failed).")

  if len == 0:
    return @[]

  result = newSeq[ByondValue](len)
  var actualLen = len

  if not Byond_Block(addr corner1, addr corner2, addr result[0], actualLen):
    raise newException(ByondCallError, "Failed to get block contents (data read failed).")

  if actualLen < len:
    result.setLen(actualLen)

proc locateXYZ*(xyz: ByondXYZ): ByondValue =
  var res: ByondValue = ByondValue.new()
  discard Byond_LocateXYZ(addr xyz, addr res)

  return res

proc getXYZ*(src: ByondValue): ByondXYZ =
  var res: ByondXYZ
  discard Byond_GetXYZ(addr src, addr res)

  return res
