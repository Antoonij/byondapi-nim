import ../byondapi_raw/byondapi, error, value/[value, constructor]

type
    ByondXYZ* = CByondXYZ

proc getBlock*(corner1, corner2: ByondXYZ): seq[ByondValue] =
  var len: u4c = 0

  handleByondError(Byond_Block(addr corner1, addr corner2, nil, len))

  if len == 0:
    return @[]

  result = newSeq[ByondValue](len)
  var actualLen = len

  handleByondError(Byond_Block(addr corner1, addr corner2, addr result[0], actualLen))

  if actualLen < len:
    result.setLen(actualLen)

proc locateXYZ*(xyz {.byref.}: ByondXYZ): ByondValue =
  result = ByondValue.init()

  discard Byond_LocateXYZ(addr xyz, addr result)

proc getXYZ*(src {.byref.}: ByondValue): ByondXYZ =
  result = ByondXYZ()
  
  discard Byond_GetXYZ(addr src, addr result)
