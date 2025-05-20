import value, ../../byondapi_raw/byondapi, ../error, constructor

converter toCfloat*(src: ByondValue): cfloat =
    src.num

converter toByondValue*(src: cfloat): ByondValue =
    ByondValue.new(src)

proc toString*(src: ByondValue): string =
  if not src.isStr():
    raise newException(ByondCallError, "String conversion on non-string value.")

  var buflen: u4c = 0
  let success = Byond_ToString(addr src, nil, buflen)

  if not success and buflen == 0:
    raise newException(ByondCallError, "Failed to convert value to string (initial size query failed).")

  if buflen == 0:
    return ""

  let raw = alloc(buflen)
  defer: dealloc(raw)

  let buffer = cast[cstring](raw)

  if not Byond_ToString(addr src, buffer, buflen):
    raise newException(ByondCallError, "Failed to convert value to string (data read failed).")

  result = $buffer