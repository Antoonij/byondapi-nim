import 
  constructor, 
  value, 
  ../../byondapi_raw/byondapi, 
  ../error, 
  options, 
  tables

proc readList*(loc {.byref.}: ByondValue): seq[ByondValue] =
  if not loc.isList():
    raise newException(ByondCallError, "List operation on non-list")

  var listBuf {.threadvar, global, gensym.}: seq[ByondValue]
  if listBuf.len == 0: listBuf.setLen(1)

  var len = listBuf.len.u4c
  let callResult = Byond_ReadList(addr loc, addr listBuf[0], addr len)

  if not callResult and len > 0:
    listBuf.setLen(len.int)
    handleByondError(Byond_ReadList(addr loc, addr listBuf[0], addr len))

  elif not callResult and len == 0:
    raise newException(ByondCallError, "ReadList failed with length 0")

  result = newSeq[ByondValue](listBuf.len)
  copyMem(result[0].addr, listBuf[0].addr, listbuf.len * sizeof(ByondValue))

proc writeList*(loc {.byref.}: ByondValue, items: seq[ByondValue]) =
  if not loc.isList():
    raise newException(ByondCallError, "List operation on non-list")

  let len = items.len.u4c
  let buffer = if len > 0: addr items[0] else: nil

  handleByondError(Byond_WriteList(addr loc, buffer, len))

proc readListAssoc*(loc {.byref.}: ByondValue): Table[ByondValue, ByondValue] =
  if not loc.isList():
    raise newException(ByondCallError, "List operation on non-list")

  var assocBuf {.threadvar, global, gensym.}: seq[ByondValue]
  if assocBuf.len == 0: assocBuf.setLen(1)

  var len = assocBuf.len.u4c
  let callResult = Byond_ReadListAssoc(addr loc, addr assocBuf[0], addr len)

  if not callResult and len > 0:
    assocBuf.setLen(len.int)
    handleByondError(Byond_ReadListAssoc(addr loc, addr assocBuf[0], addr len))

  elif not callResult and len == 0:
    raise newException(ByondCallError, "ReadListAssoc failed with length 0")

  result = initTable[ByondValue, ByondValue](len.int div 2)

  for i in countup(0, len.int - 2, 2):
    result[assocBuf[i]] = assocBuf[i+1]

proc `[]`*(loc {.byref.}: ByondValue, idx: ByondValue): ByondValue =
  if not loc.isList():
    raise newException(ByondCallError, "List operation on non-list")

  result = ByondValue.init()

  handleByondError(Byond_ReadListIndex(addr loc, addr idx, addr result))

proc `[]=`*(loc {.byref.}: ByondValue, idx: ByondValue, val: ByondValue) =
  if not loc.isList():
    raise newException(ByondCallError, "List operation on non-list")
  
  handleByondError(Byond_WriteListIndex(addr loc, addr idx, addr val))

proc locateIn*(src {.byref.}: ByondValue, listParam: ByondValue): Option[ByondValue] =
  var wrappedResult = ByondValue.init()

  handleByondError(Byond_LocateIn(addr src, addr listParam, addr wrappedResult))

  if wrappedResult.isNull():
    return none(ByondValue)

  some(wrappedResult)

proc length*(src {.byref.}: ByondValue): ByondValue =
  result = ByondValue.init()

  handleByondError(Byond_Length(addr src, addr result))

proc len*(src {.byref.}: ByondValue): cfloat {.inline.} = src.length().num
