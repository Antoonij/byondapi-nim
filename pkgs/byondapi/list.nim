import value/[constructor, value], ../byondapi_raw/byondapi, error, std/options

proc readList*(loc {.byref.}: ByondValue): seq[ByondValue] =
  if not loc.isList():
    raise newException(ByondCallError, "List operation on non-list")

  var len: u4c = 0
  let success = Byond_ReadList(addr loc, nil, len)

  if not success and len == 0:
    raise newException(ByondCallError, "Failed to read list (initial size query failed).")

  if len == 0:
    return @[]

  result = newSeq[ByondValue](len)
  var actualLen = len

  if not Byond_ReadList(addr loc, addr result[0], actualLen):
    raise newException(ByondCallError, "Failed to read list (data read failed).")

  if actualLen < len:
    result.setLen(actualLen)

proc writeList*(loc {.byref.}: ByondValue, items: seq[ByondValue]) =
  if not loc.isList():
    raise newException(ByondCallError, "List operation on non-list")

  let len = items.len.u4c
  let buffer = if len > 0: addr items[0] else: nil

  if not Byond_WriteList(addr loc, buffer, len):
    raise newException(ByondCallError, "Failed to write list.")

proc readListAssoc*(loc {.byref.}: ByondValue): seq[ByondValue] =
  if not loc.isList():
    raise newException(ByondCallError, "List operation on non-list")

  var len: u4c = 0
  let success = Byond_ReadListAssoc(addr loc, nil, len)

  if not success and len == 0:
    raise newException(ByondCallError, "Failed to read associative list (initial size query failed).")

  if len == 0:
    return @[]

  result = newSeq[ByondValue](len)
  var actualLen = len
  
  if not Byond_ReadListAssoc(addr loc, addr result[0], actualLen):
    raise newException(ByondCallError, "Failed to read associative list (data read failed).")

  if actualLen < len:
    result.setLen(actualLen)

proc readListIndex*(loc {.byref.}: ByondValue, idx: ByondValue): ByondValue =
  if not loc.isList():
    raise newException(ByondCallError, "List operation on non-list")

  result = ByondValue.new()

  if not Byond_ReadListIndex(addr loc, addr idx, addr result):
    raise newException(ByondCallError, "Failed to read list index.")

proc writeListIndex*(loc {.byref.}: ByondValue, idx: ByondValue, val: ByondValue) =
  if not loc.isList():
    raise newException(ByondCallError, "List operation on non-list")
  
  if not Byond_WriteListIndex(addr loc, addr idx, addr val):
    raise newException(ByondCallError, "Failed to write list index.")

proc locateIn*(src {.byref.}: ByondValue, listParam: ByondValue): Option[ByondValue] =
  var wrappedResult = ByondValue.new()

  if not Byond_LocateIn(addr src, addr listParam, addr wrappedResult):
    raise newException(ByondCallError, "Failed during locateIn API call.")

  if wrappedResult.isNull():
    return none[ByondValue]()

  return some(wrappedResult)

proc length*(src {.byref.}: ByondValue): ByondValue =
  result = ByondValue.new()

  if not Byond_Length(addr src, addr result):
    raise newException(ByondCallError, "Failed to get length.")

proc len*(src {.byref.}: ByondValue): cfloat = src.length().num
