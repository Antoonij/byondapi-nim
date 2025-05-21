import ../byondapi_raw/byondapi, error, value/[value, constructor]

proc readVar*(loc {.byref.}: ByondValue, varname: string): ByondValue =
  result = ByondValue.new()

  if not Byond_ReadVar(addr loc, varname.cstring, addr result):
    raise newException(ByondCallError, "Failed to read var '" & varname & "' on object.")

proc readVar*(loc {.byref.}: ByondValue, varnameId: u4c): ByondValue =
  result = ByondValue.new()

  if not Byond_ReadVarByStrId(addr loc, varnameId, addr result):
    raise newException(ByondCallError, "Failed to read var with ID " & $varnameId & " on object.")
  
proc writeVar*(loc {.byref.}: ByondValue, varname: string, val: ByondValue) =
  if not Byond_WriteVar(addr loc, varname.cstring, addr val):
    raise newException(ByondCallError, "Failed to write var '" & varname & "' on object.")

proc writeVar*(loc {.byref.}: ByondValue, varnameId: u4c, val: ByondValue) =
  if not Byond_WriteVarByStrId(addr loc, varnameId, addr val):
    raise newException(ByondCallError, "Failed to write var with ID " & $varnameId & " on object.")
