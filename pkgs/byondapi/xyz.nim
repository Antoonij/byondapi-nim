import ../byondapi_raw/byondapi, error, value/[value, constructor]

type
    ByondXYZ* = CByondXYZ

proc getBlock*(corner1, corner2: ByondXYZ): seq[ByondValue] =
  var blockBuf {.threadvar, global, gensym.}: seq[ByondValue]

  if blockBuf.len == 0:
    blockBuf.setLen(1)

  var len = blockBuf.len.u4c
  let callResult = Byond_Block(addr corner1, addr corner2, addr blockBuf[0], addr len)

  if not callResult and len > 0:
    blockBuf.setLen(len.int)
    handleByondError(Byond_Block(addr corner1, addr corner2, addr blockBuf[0],  addr len))

  elif not callResult and len == 0:
    raise newException(ByondCallError, "Byond_Block failed with length 0")

  blockBuf[0 ..< len.int]

proc locateXYZ*(xyz {.byref.}: ByondXYZ): ByondValue =
  result = ByondValue.init()

  discard Byond_LocateXYZ(addr xyz, addr result)

proc getXYZ*(src {.byref.}: ByondValue): ByondXYZ =
  result = ByondXYZ()
  
  discard Byond_GetXYZ(addr src, addr result)
