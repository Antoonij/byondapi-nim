import ../error, ../../byondapi_raw/byondapi, constructor, value

proc callProc*(src {.byref.}: ByondValue, name: string, args: openArray[ByondValue]): ByondValue =
  result = ByondValue.new()

  let argCount = args.len.u4c
  let argPtr = if argCount > 0: addr args[0] else: nil

  handleByondError(Byond_CallProc(addr src, name.cstring, argPtr, argCount, addr result))

proc callProc*(src {.byref.}: ByondValue, nameId: u4c, args: openArray[ByondValue]): ByondValue =
  result = ByondValue.new()

  let argCount = args.len.u4c
  let argPtr = if argCount > 0: addr args[0] else: nil

  handleByondError(Byond_CallProcByStrId(addr src, nameId, argPtr, argCount, addr result))
