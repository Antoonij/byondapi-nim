import value/[constructor, value], ../byondapi_raw/byondapi, error, std/options

proc readList*(loc {.byref.}: ByondValue): seq[ByondValue] =
  if not loc.isList():
    raise newException(ByondCallError, "List operation on non-list")

  var len: u4c = 0
  handleByondError(Byond_ReadList(addr loc, nil, len))

  if len == 0:
    return @[]

  result = newSeq[ByondValue](len)
  var actualLen = len

  handleByondError(Byond_ReadList(addr loc, addr result[0], actualLen))

  if actualLen < len:
    result.setLen(actualLen)

proc writeList*(loc {.byref.}: ByondValue, items: seq[ByondValue]) =
  if not loc.isList():
    raise newException(ByondCallError, "List operation on non-list")

  let len = items.len.u4c
  let buffer = if len > 0: addr items[0] else: nil

  handleByondError(Byond_WriteList(addr loc, buffer, len))

proc readListAssoc*(loc {.byref.}: ByondValue): seq[ByondValue] =
  if not loc.isList():
    raise newException(ByondCallError, "List operation on non-list")

  var len: u4c = 0
  handleByondError(Byond_ReadListAssoc(addr loc, nil, len))

  if len == 0:
    return @[]

  result = newSeq[ByondValue](len)
  var actualLen = len
  
  handleByondError(Byond_ReadListAssoc(addr loc, addr result[0], actualLen))

  if actualLen < len:
    result.setLen(actualLen)

proc readListIndex*(loc {.byref.}: ByondValue, idx: ByondValue): ByondValue =
  if not loc.isList():
    raise newException(ByondCallError, "List operation on non-list")

  result = ByondValue.new()

  handleByondError(Byond_ReadListIndex(addr loc, addr idx, addr result))

proc writeListIndex*(loc {.byref.}: ByondValue, idx: ByondValue, val: ByondValue) =
  if not loc.isList():
    raise newException(ByondCallError, "List operation on non-list")
  
  handleByondError(Byond_WriteListIndex(addr loc, addr idx, addr val))

proc locateIn*(src {.byref.}: ByondValue, listParam: ByondValue): Option[ByondValue] =
  var wrappedResult = ByondValue.new()

  handleByondError(Byond_LocateIn(addr src, addr listParam, addr wrappedResult))

  if wrappedResult.isNull():
    return none(ByondValue)

  return some(wrappedResult)

proc length*(src {.byref.}: ByondValue): ByondValue =
  result = ByondValue.new()

  handleByondError(Byond_Length(addr src, addr result))

proc len*(src {.byref.}: ByondValue): cfloat = src.length().num
