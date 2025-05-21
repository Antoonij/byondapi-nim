import value/[value, constructor], ../byondapi_raw/byondapi, error

proc readPointer*(ptrVal {.byref.}: ByondValue): ByondValue =
  result = ByondValue.new()

  if not Byond_ReadPointer(addr ptrVal, addr result):
    raise newException(ByondCallError, "Failed to read pointer.")

proc writePointer*(ptrVal {.byref.}: ByondValue, val: ByondValue) =
  if not Byond_WritePointer(addr ptrVal, addr val):
    raise newException(ByondCallError, "Failed to write pointer.")
