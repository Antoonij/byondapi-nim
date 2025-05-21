import error, ../byondapi_raw/byondapi, value/[constructor, value]

proc callProc*(src: ByondValue, name: string, args: openArray[ByondValue]): ByondValue =
  result = ByondValue.new()
  let argCount = args.len.u4c
  let argPtr = if argCount > 0: addr args[0] else: nil

  if not Byond_CallProc(addr src, name.cstring, argPtr, argCount, addr result):
    raise newException(ByondCallError, "Failed to call proc '" & name & "' on object.")

proc callProc*(src: ByondValue, nameId: u4c, args: openArray[ByondValue]): ByondValue =
  result = ByondValue.new()
  let argCount = args.len.u4c
  let argPtr = if argCount > 0: addr args[0] else: nil

  if not Byond_CallProcByStrId(addr src, nameId, argPtr, argCount, addr result):
    raise newException(ByondCallError, "Failed to call proc with ID " & $nameId & " on object.")

proc callGlobalProc*(name: string, args: openArray[ByondValue]): ByondValue =
  result = ByondValue.new()
  let argCount = args.len.u4c
  let argPtr = if argCount > 0: addr args[0] else: nil

  if not Byond_CallGlobalProc(name.cstring, argPtr, argCount, addr result):
    raise newException(ByondCallError, "Failed to call global proc '" & name & "'.")

proc callGlobalProc*(nameId: u4c, args: openArray[ByondValue]): ByondValue =
  result = ByondValue.new()
  let argCount = args.len.u4c
  let argPtr = if argCount > 0: addr args[0] else: nil

  if not Byond_CallGlobalProcByStrId(nameId, argPtr, argCount, addr result):
    raise newException(ByondCallError, "Failed to call global proc with ID " & $nameId & ".")
