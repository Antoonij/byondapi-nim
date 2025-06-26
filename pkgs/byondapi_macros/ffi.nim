import 
  macros,
  ../byondapi_raw/byondapi, 
  ../byondapi/[global_proc, strings, error],
  ../byondapi/value/[value, constructor]

template toSafeArray(argv: ptr UncheckedArray[ByondValue]): ptr UncheckedArray[ByondValue] =
  var arr {.gensym.}: array[0, ByondValue]
  if argv.isNil: cast[ptr UncheckedArray[ByondValue]](addr arr) else: argv

macro byondProc*(body: untyped): untyped =
  result = newStmtList()

  let ffiNameStr = $body.name & "_ffi"
  let ffiIdent = ident(ffiNameStr)

  result.add(body)

  let clr: NimNode = newNimNode(nnkCall)
  clr.add(body.name)
  
  let argsIdent = ident("argValues")
  let argCount = ident("argCount")

  for paramIdx in 0 ..< body.params.len - 1:
    clr.add(quote do:
      if `argCount`.int > `paramIdx`: `argsIdent`[`paramIdx`] else: ByondValue.init()
    )

  let wrapper = quote do:
    proc `ffiIdent`*(`argCount`: u4c, argv: ptr UncheckedArray[ByondValue]): ByondValue {.cdecl, dynlib, exportc.} =
      result = ByondValue.init()

      let `argsIdent` = argv.toSafeArray()
      let exceptionLogger = "byondapi_stack_trace".strId()
    
      try:
        result = `clr`

      except ByondCallError as err:
        discard callGlobalProc(exceptionLogger, [ByondValue.init(err.cstrmsg)])

      except CatchableError as err:
        discard callGlobalProc(exceptionLogger, [ByondValue.init(err.msg)])

  result.add(wrapper)

macro byondAsyncProc*(body: untyped): untyped =
  result = newStmtList()

  let ffiNameStr = $body.name & "_ffi"
  let ffiIdent = ident(ffiNameStr)

  result.add(body)

  let clr: NimNode = newNimNode(nnkCall)
  clr.add(body.name)

  let sleepingProcIdent = ident("sleepingProc")
  clr.add(sleepingProcIdent)

  let argsIdent = ident("argValues")
  let argCount = ident("argCount")

  for paramIdx in 1 ..< body.params.len - 1:
    let idx = paramIdx - 1

    clr.add(quote do:
      if `argCount`.int > `idx`: `argsIdent`[`idx`] else: ByondValue.init()
    )

  let wrapper = quote do:
    proc `ffiIdent`*(`argCount`: u4c, argv: ptr UncheckedArray[ByondValue], `sleepingProcIdent`: ByondValue): void {.cdecl, dynlib, exportc.} =
      let `argsIdent` = argv.toSafeArray()
      let exceptionLogger = "byondapi_stack_trace".strId()

      try:
        `clr`

      except ByondCallError as err:
        discard callGlobalProc(exceptionLogger, [ByondValue.init(err.cstrmsg)])

      except CatchableError as err:
        discard callGlobalProc(exceptionLogger, [ByondValue.init(err.msg)])

  result.add(wrapper)
