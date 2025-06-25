import ../../byondapi_raw/byondapi, ../error, value, constructor

proc readVar*(src {.byref.}: ByondValue, varname: cstring): ByondValue =
  result = ByondValue.init()

  handleByondError(Byond_ReadVar(addr src, varname, addr result))

template readVar*(src: ByondValue, varname: string): ByondValue = 
  readVar(src, varname.cstring)

proc readVar*(src {.byref.}: ByondValue, varnameId: u4c): ByondValue =
  result = ByondValue.init()

  handleByondError(Byond_ReadVarByStrId(addr src, varnameId, addr result))
  
proc writeVar*(src {.byref.}: ByondValue, varname: cstring, val: ByondValue) =
  handleByondError(Byond_WriteVar(addr src, varname, addr val))

template writeVar*(src: ByondValue, varname: string, val: ByondValue) =
  writeVar(src, varname.cstring, val)

proc writeVar*(src {.byref.}: ByondValue, varnameId: u4c, val: ByondValue) =
  handleByondError(Byond_WriteVarByStrId(addr src, varnameId, addr val))
