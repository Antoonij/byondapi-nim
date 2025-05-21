import value/[value, constructor], ../byondapi_raw/byondapi, error

proc readPointer*(ptrVal: ByondValue): ByondValue =
  result = ByondValue.new()

  if not Byond_ReadPointer(addr ptrVal, addr result):
    raise newException(ByondCallError, "Failed to read pointer.")

proc writePointer*(ptrVal: ByondValue, val: ByondValue) =
  if not Byond_WritePointer(addr ptrVal, addr val):
    raise newException(ByondCallError, "Failed to write pointer.")
