import ../byondapi_raw/byondapi, error, value/[value, constructor]

proc readVar*(loc: ByondValue, varname: string): ByondValue =
  var res: ByondValue = ByondValue.new()

  if not Byond_ReadVar(addr loc, varname.cstring, addr res):
    raise newException(ByondCallError, "Failed to read var '" & varname & "' on object.")

  return res

proc readVar*(loc: ByondValue, varnameId: u4c): ByondValue =
  var res: ByondValue = ByondValue.new()

  if not Byond_ReadVarByStrId(addr loc, varnameId, addr res):
    raise newException(ByondCallError, "Failed to read var with ID " & $varnameId & " on object.")

  return res

proc writeVar*(loc: ByondValue, varname: string, val: ByondValue) =
  if not Byond_WriteVar(addr loc, varname.cstring, addr val):
    raise newException(ByondCallError, "Failed to write var '" & varname & "' on object.")

proc writeVar*(loc: ByondValue, varnameId: u4c, val: ByondValue) =
  if not Byond_WriteVarByStrId(addr loc, varnameId, addr val):
    raise newException(ByondCallError, "Failed to write var with ID " & $varnameId & " on object.")
