import error, ../byondapi_raw/byondapi, value/[constructor, value]

proc callProc*(src: ByondValue, name: string, args: openArray[ByondValue]): ByondValue =
  var res: ByondValue = ByondValue.new()
  let argCount = args.len.u4c
  let argPtr = if argCount > 0: addr args[0] else: nil

  if not Byond_CallProc(addr src, name.cstring, argPtr, argCount, addr res):
    raise newException(ByondCallError, "Failed to call proc '" & name & "' on object.")

  return res

proc callProc*(src: ByondValue, nameId: u4c, args: openArray[ByondValue]): ByondValue =
  var res: ByondValue = ByondValue.new()
  let argCount = args.len.u4c
  let argPtr = if argCount > 0: addr args[0] else: nil

  if not Byond_CallProcByStrId(addr src, nameId, argPtr, argCount, addr res):
    raise newException(ByondCallError, "Failed to call proc with ID " & $nameId & " on object.")

  return res

proc callGlobalProc*(name: string, args: openArray[ByondValue]): ByondValue =
  var res: ByondValue = ByondValue.new()
  let argCount = args.len.u4c
  let argPtr = if argCount > 0: addr args[0] else: nil

  if not Byond_CallGlobalProc(name.cstring, argPtr, argCount, addr res):
    raise newException(ByondCallError, "Failed to call global proc '" & name & "'.")

  return res

proc callGlobalProc*(nameId: u4c, args: openArray[ByondValue]): ByondValue =
  var res: ByondValue = ByondValue.new()
  let argCount = args.len.u4c
  let argPtr = if argCount > 0: addr args[0] else: nil

  if not Byond_CallGlobalProcByStrId(nameId, argPtr, argCount, addr res):
    raise newException(ByondCallError, "Failed to call global proc with ID " & $nameId & ".")

  return res
