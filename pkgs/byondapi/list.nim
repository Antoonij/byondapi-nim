import value/[constructor, value], ../byondapi_raw/byondapi, error, std/options, type_tag

proc readList*(loc: ByondValue): seq[ByondValue] =
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

proc writeList*(loc: ByondValue, items: seq[ByondValue]) =
  if not loc.isList():
    raise newException(ByondCallError, "List operation on non-list")

  let len = items.len.u4c
  let buffer = if len > 0: addr items[0] else: nil

  if not Byond_WriteList(addr loc, buffer, len):
    raise newException(ByondCallError, "Failed to write list.")

proc readListAssoc*(loc: ByondValue): seq[ByondValue] =
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

proc readListIndex*(loc: ByondValue, idx: ByondValue): ByondValue =
  if not loc.isList():
    raise newException(ByondCallError, "List operation on non-list")

  var res: ByondValue = ByondValue.new()

  if not Byond_ReadListIndex(addr loc, addr idx, addr res):
    raise newException(ByondCallError, "Failed to read list index.")

  return res

proc writeListIndex*(loc: ByondValue, idx: ByondValue, val: ByondValue) =
  if not loc.isList():
    raise newException(ByondCallError, "List operation on non-list")
  
  if not Byond_WriteListIndex(addr loc, addr idx, addr val):
    raise newException(ByondCallError, "Failed to write list index.")

proc locateIn*(typ: ByondValue, listParam: ByondValue): Option[ByondValue] =
  var res: ByondValue = ByondValue.new()

  if not Byond_LocateIn(addr typ, addr listParam, addr res):
    raise newException(ByondCallError, "Failed during locateIn API call.")

  if res.isNull():
    return none[ByondValue]()

  return some(res)

proc length*(src: ByondValue): ByondValue =
  var res: ByondValue = ByondValue.new()

  if not Byond_Length(addr src, addr res):
    raise newException(ByondCallError, "Failed to get length.")

  return res

proc len*(src: ByondValue): cfloat = src.length().num

proc newArglist*(typ: ByondValue, arglist: ByondValue): ByondValue =
  var res: ByondValue = ByondValue.new()

  if not Byond_NewArglist(addr typ, addr arglist, addr res):
    raise newException(ByondCallError, "Failed to create new object of type using arglist.")

  return res