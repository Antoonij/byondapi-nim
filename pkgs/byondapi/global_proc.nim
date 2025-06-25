import error, ../byondapi_raw/byondapi, value/[constructor, value]

proc callGlobalProc*(name: cstring, args: openArray[ByondValue]): ByondValue =
  result = ByondValue.init()

  let argCount = args.len.u4c
  let argPtr = if argCount > 0: addr args[0] else: nil

  handleByondError(Byond_CallGlobalProc(name, argPtr, argCount, addr result))

template callGlobalProc*(name: string, args: openArray[ByondValue]): ByondValue =
  callGlobalProc(name.cstring, args)

proc callGlobalProc*(nameId: u4c, args: openArray[ByondValue]): ByondValue =
  result = ByondValue.init()
  
  let argCount = args.len.u4c
  let argPtr = if argCount > 0: addr args[0] else: nil

  handleByondError(Byond_CallGlobalProcByStrId(nameId, argPtr, argCount, addr result))
