import value/[value, constructor], ../byondapi_raw/byondapi, error

proc readPointer*(ptrVal: ByondValue): ByondValue =
  var res: ByondValue = ByondValue.new()

  if not Byond_ReadPointer(addr ptrVal, addr res):
    raise newException(ByondCallError, "Failed to read pointer.")

  return res

proc writePointer*(ptrVal: ByondValue, val: ByondValue) =
  if not Byond_WritePointer(addr ptrVal, addr val):
    raise newException(ByondCallError, "Failed to write pointer.")
