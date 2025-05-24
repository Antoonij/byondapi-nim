import value, ../../byondapi_raw/byondapi, ../error, constructor

converter toCfloat*(src: ByondValue): cfloat =
    src.num

converter toByondValue*(src: cfloat): ByondValue =
    ByondValue.new(src)

proc toString*(src {.byref.}: ByondValue): string =
  if not src.isStr():
    raise newException(ByondCallError, "String conversion on non-string value.")

  var buflen: u4c = 0

  handleByondError(Byond_ToString(addr src, nil, buflen))

  if buflen == 0:
    return ""

  let raw = alloc(buflen)
  defer: dealloc(raw)

  let buffer = cast[cstring](raw)

  handleByondError(Byond_ToString(addr src, buffer, buflen))

  $buffer
