import value, ../error, ../../byondapi_raw/byondapi

proc incRef*(src {.byref.}: ByondValue) = ByondValue_IncRef(addr src)

proc decRef*(src {.byref.}: ByondValue) = ByondValue_DecRef(addr src)

when BYOND_MAJOR >= 516 and BYOND_MINOR >= 1651:
  proc decTempRef*(src {.byref.}: ByondValue) = ByondValue_DecTempRef(addr src)

proc testRef*(src: var ByondValue): bool = Byond_TestRef(addr src)

proc refcount*(src {.byref.}: ByondValue): u4c =
  result = 0

  handleByondError(Byond_Refcount(addr src, addr result))

type
  TracedByondValue* = object
    inner*: ByondValue

template `.`*(src: TracedByondValue, field: untyped): untyped =
  src.inner.`field`

proc `=destroy`*(src: var TracedByondValue) =
  src.decRef()

proc `=copy`*(dest: var TracedByondValue, src: TracedByondValue) =
  dest = src
  dest.incRef()

converter toTraced*(src: ByondValue): TracedByondValue =
  src.incRef()
  TracedByondValue(inner: src)
