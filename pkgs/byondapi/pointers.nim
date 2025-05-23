import value/[value, constructor], ../byondapi_raw/byondapi, error

proc readPointer*(ptrVal {.byref.}: ByondValue): ByondValue =
  result = ByondValue.new()

  handleByondError(Byond_ReadPointer(addr ptrVal, addr result))

proc writePointer*(ptrVal {.byref.}: ByondValue, val: ByondValue) =
  handleByondError(Byond_WritePointer(addr ptrVal, addr val))
