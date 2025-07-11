import ../error, ../../byondapi_raw/byondapi, constructor, value, ../../byond_version

proc callProc*(src {.byref.}: ByondValue, name: cstring, args: openArray[ByondValue]): ByondValue =
  result = ByondValue.init()

  let argCount = args.len.u4c
  let argPtr = if argCount > 0: addr args[0] else: nil

  handleByondError(Byond_CallProc(addr src, name, argPtr, argCount, addr result))

template callProc*(src: ByondValue, name: string, args: openArray[ByondValue]): ByondValue =
  callProc(src, name.cstring, args)

proc callProc*(src {.byref.}: ByondValue, nameId: u4c, args: openArray[ByondValue]): ByondValue =
  result = ByondValue.init()

  let argCount = args.len.u4c
  let argPtr = if argCount > 0: addr args[0] else: nil

  handleByondError(Byond_CallProcByStrId(addr src, nameId, argPtr, argCount, addr result))

proc returnProc*(src {.byref.}: ByondValue, retval: ByondValue): void {.byond(516.1664).} =
  handleByondError(Byond_Return(addr src, addr retval))
