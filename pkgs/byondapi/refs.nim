import value/value, error, ../byondapi_raw/byondapi

proc incRef*(src {.byref.}: ByondValue) = ByondValue_IncRef(addr src)

proc decRef*(src {.byref.}: ByondValue) = ByondValue_DecRef(addr src)

when BYOND_MAJOR >= 516 and BYOND_MINOR >= 1651:
  proc decTempRef*(src {.byref.}: ByondValue) = ByondValue_DecTempRef(addr src)

proc testRef*(src: var ByondValue): bool = Byond_TestRef(addr src)

proc refcount*(src {.byref.}: ByondValue): u4c =
  result = 0

  handleByondError(Byond_Refcount(addr src, addr result))
