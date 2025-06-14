import ../../byondapi_raw/byondapi, ../error, ../../byond_version

type
    ByondValue* = CByondValue

proc isNull*(v {.byref.}: ByondValue): bool = ByondValue_IsNull(addr v)
proc isNum*(v {.byref.}: ByondValue): bool = ByondValue_IsNum(addr v)
proc isStr*(v {.byref.}: ByondValue): bool = ByondValue_IsStr(addr v)
proc isList*(v {.byref.}: ByondValue): bool = ByondValue_IsList(addr v)
proc isTrue*(v {.byref.}: ByondValue): bool = ByondValue_IsTrue(addr v)

when ByondVersion >= 516.1664:
  proc isType*(src {.byref.}: ByondValue, typestr: string): bool = ByondValue_IsType(addr src, typestr.cstring)

proc num*(v {.byref.}: ByondValue): cfloat = ByondValue_GetNum(addr v)
proc `num=`*(v: var ByondValue, f: cfloat) = ByondValue_SetNum(addr v, f)

proc `ref`*(v {.byref.}: ByondValue): u4c = ByondValue_GetRef(addr v)
proc `ref=`*(v: var ByondValue, refVal: u4c) = ByondValue_SetRef(addr v, v.xtype, refVal)

proc `type`*(a {.byref.}: ByondValue): ByondValueType = ByondValue_GetType(addr a)

proc `==`*(a {.byref.}: ByondValue, b: ByondValue): bool = ByondValue_Equals(addr a, addr b)
proc `!=`*(a {.byref.}: ByondValue, b: ByondValue): bool = not ByondValue_Equals(addr a, addr b)

proc clear*(v: var ByondValue) = ByondValue_Clear(addr v)

proc getString*(src {.byref.}: ByondValue): string =
  if not src.isStr():
    raise newException(ByondCallError, "Cannot get string from non-string value.")

  var buflen: u4c = 0

  handleByondError(Byond_ToString(addr src, nil, buflen))

  if buflen == 0:
    return ""

  let raw = alloc(buflen)
  defer: dealloc(raw)

  let buffer = cast[cstring](raw)

  handleByondError(Byond_ToString(addr src, buffer, buflen))

  $buffer
