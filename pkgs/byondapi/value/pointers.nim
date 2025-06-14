import value, constructor, ../../byondapi_raw/byondapi, ../error

proc readPointer*(ptrVal {.byref.}: ByondValue): ByondValue =
  result = ByondValue.init()

  handleByondError(Byond_ReadPointer(addr ptrVal, addr result))

proc writePointer*(ptrVal {.byref.}: ByondValue, val: ByondValue) =
  handleByondError(Byond_WritePointer(addr ptrVal, addr val))
