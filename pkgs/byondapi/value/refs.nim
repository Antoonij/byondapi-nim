import value, ../error, ../../byondapi_raw/byondapi, ../../byond_version

proc incRef*(src {.byref.}: ByondValue) {.inline.} = 
  ByondValue_IncRef(addr src)

proc decRef*(src {.byref.}: ByondValue) {.inline.} = 
  ByondValue_DecRef(addr src)

proc decTempRef*(src {.byref.}: ByondValue) {.byond(516.1651), inline.} = 
  ByondValue_DecTempRef(addr src)

proc testRef*(src: var ByondValue): bool {.inline.} = 
  Byond_TestRef(addr src)

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
  result = TracedByondValue(inner: src)
  src.incRef()
