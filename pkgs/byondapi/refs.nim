import value/value, error, ../byondapi_raw/byondapi

proc incRef*(src: ByondValue) = ByondValue_IncRef(addr src)

proc decRef*(src: ByondValue) = ByondValue_DecRef(addr src)

proc decTempRef*(src: ByondValue) = ByondValue_DecTempRef(addr src)

proc testRef*(src: var ByondValue): bool = Byond_TestRef(addr src)

proc refcount*(src: ByondValue): u4c =
  result = 0

  if not Byond_Refcount(addr src, addr result):
    raise newException(ByondCallError, "Failed to get refcount.")
