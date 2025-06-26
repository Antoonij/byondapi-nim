import 
  macros,
  ../byondapi_raw/byondapi, 
  ../byondapi/[global_proc, strings, error],
  ../byondapi/value/[value, constructor]

const maxParamCount = 128

# Unsafest thing, but fast. Only for data copy.
proc fromRawPartsToSeq(argv: ptr ByondValue, argc: int, paramCount: int): lent seq[ByondValue] =
  var cache {.global, threadvar, gensym.}: seq[ByondValue]
  if cache.len == 0: cache.setLen(maxParamCount)

  if not argv.isNil and paramCount > 0:
    let count = min(argc, paramCount)
    let bytesToCopy = count * sizeof(ByondValue)
    copyMem(cache[0].addr, argv, bytesToCopy)

  for i in argc ..< paramCount:
    cache[i] = ByondValue.init()

  cache

macro byondProc*(body: untyped): untyped =
  result = newStmtList()

  let ffiNameStr = $body.name & "_ffi"
  let ffiIdent= ident(ffiNameStr)

  result.add(body)

  let clr: NimNode = newNimNode(nnkCall)
  clr.add(body.name)

  var i = body.params.len - 1
  let argsIdent = ident("argsToProc")

  for paramIdx in 1..i:
    var expre = newNimNode(nnkBracketExpr)
    expre.add(argsIdent, newLit(paramIdx - 1))
    clr.add(expre)

  let overallParams = newLit(i)

  let wrapper = quote do:
    proc `ffiIdent`*(argc: u4c, argv: ptr ByondValue): ByondValue {.cdecl, dynlib, exportc.} =
      result = ByondValue.init()
      let `argsIdent` = fromRawPartsToSeq(argv, argc.int, `overallParams`)
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

  let i = body.params.len - 1
  let argsIdent = ident("argsToProc")

  for paramIdx in 2..i:
    var expre = newNimNode(nnkBracketExpr)
    expre.add(argsIdent, newLit(paramIdx - 2))
    clr.add(expre)
    
  let overallParams = newLit(i - 1)

  let wrapper = quote do:
    proc `ffiIdent`*(argc: u4c, argv: ptr ByondValue, `sleepingProcIdent`: ByondValue): void {.cdecl, dynlib, exportc.} =
      let `argsIdent` = fromRawPartsToSeq(argv, argc.int, `overallParams`)
      let exceptionLogger = "byondapi_stack_trace".strId()

      try:
        `clr`

      except ByondCallError as err:
        discard callGlobalProc(exceptionLogger, [ByondValue.init(err.cstrmsg)])

      except CatchableError as err:
        discard callGlobalProc(exceptionLogger, [ByondValue.init(err.msg)])

  result.add(wrapper)
