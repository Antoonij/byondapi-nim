import ../../byondapi_raw/byondapi, ../error, value, constructor

proc readVar*(loc {.byref.}: ByondValue, varname: string): ByondValue =
  result = ByondValue.init()

  handleByondError(Byond_ReadVar(addr loc, varname.cstring, addr result))

proc readVar*(loc {.byref.}: ByondValue, varnameId: u4c): ByondValue =
  result = ByondValue.init()

  handleByondError(Byond_ReadVarByStrId(addr loc, varnameId, addr result))
  
proc writeVar*(loc {.byref.}: ByondValue, varname: string, val: ByondValue) =
  handleByondError(Byond_WriteVar(addr loc, varname.cstring, addr val))

proc writeVar*(loc {.byref.}: ByondValue, varnameId: u4c, val: ByondValue) =
  handleByondError(Byond_WriteVarByStrId(addr loc, varnameId, addr val))
