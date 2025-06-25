import 
  macros, 
  ../byondapi_raw/byondapi, 
  ../byondapi/[global_proc, strings, error],
  ../byondapi/value/[value, constructor]

proc fromRawPartsToSeq(argv: ptr ByondValue, argc: int, paramCount: int): seq[ByondValue] =
  result = newSeq[ByondValue](paramCount)

  if not argv.isNil and argc > 0:
    let count = min(argc, paramCount)
    let bytesToCopy = count * sizeof(ByondValue)
    copyMem(result[0].addr, argv, bytesToCopy)

  for i in argc ..< paramCount:
    result[i] = ByondValue.init()

macro byondProc*(body: untyped): untyped =
  if body.kind != nnkStmtList:
    error("byondProc must be followed by a block of proc definitions", body)

  var output: seq[NimNode] = @[]

  for stmt in body:
    if stmt.kind != nnkProcDef:
      output.add(stmt)
      continue

    let procDef = stmt
    var nameNode: NimNode = nil

    for child in procDef.children:
      if child.kind == nnkIdent:
        nameNode = child
        break

    if nameNode.isNil:
      error("Could not find the procedure name (nnkIdent node) within the proc definition AST.", procDef)

    let nameStr = $nameNode
    let ffiNameStr = nameStr & "_ffi"
    let ffiIdent = ident(ffiNameStr)

    output.add(procDef)

    var formalParams: NimNode = nil
    for chld in procDef:
      if chld.kind != nnkFormalParams:
        continue

      formalParams = chld
      break

    let clr: NimNode = newNimNode(nnkCall)
    clr.add(nameNode)

    var i = 0
    let argsIdent = ident("argsToProc")

    for chld in formalParams:
      if chld.kind != nnkIdentDefs:
        continue
      
      var expre = newNimNode(nnkBracketExpr)
      expre.add(argsIdent, newLit(i))
      clr.add(expre)
      i.inc

    var overallParams = newLit(i)

    let wrapper = quote do:
      proc `ffiIdent`*(argc: u4c, argv: ptr ByondValue): ByondValue {.cdecl, dynlib, exportc: `ffiNameStr`.} =
        result = ByondValue.init()
        let `argsIdent` = fromRawPartsToSeq(argv, argc.int, `overallParams`)
    
        try:
          result = `clr`

        except ByondCallError as err:
          discard callGlobalProc("byondapi_stack_trace".strId(), [ByondValue.init(err.cstrmsg)])

        except CatchableError as err:
          discard callGlobalProc("byondapi_stack_trace".strId(), [ByondValue.init(err.msg)])

    output.add(wrapper)

  result = newStmtList(output)

macro byondAsyncProc*(body: untyped): untyped =
  if body.kind != nnkStmtList:
    error("byondAsyncProc must be followed by a block of proc definitions", body)

  var output: seq[NimNode] = @[]

  for stmt in body:
    if stmt.kind != nnkProcDef:
      output.add(stmt)
      continue

    let procDef = stmt
    var nameNode: NimNode = nil

    for child in procDef.children:
      if child.kind == nnkIdent:
        nameNode = child
        break

    if nameNode.isNil:
      error("Could not find the procedure name (nnkIdent node) within the proc definition AST.", procDef)

    let nameStr = $nameNode
    let ffiNameStr = nameStr & "_ffi"
    let ffiIdent = ident(ffiNameStr)

    output.add(procDef)

    var formalParams: NimNode = nil
    for chld in procDef:
      if chld.kind != nnkFormalParams:
        continue

      formalParams = chld
      break

    let clr: NimNode = newNimNode(nnkCall)
    clr.add(nameNode)

    let sleepingProcIdent = ident("sleepingProc")
    clr.add(sleepingProcIdent)

    var i = 0
    let argsIdent = ident("argsToProc")

    for chld in formalParams:
      if chld.kind != nnkIdentDefs:
        continue
      
      i.inc

    for paramIdx in 2..i:
      var expre = newNimNode(nnkBracketExpr)
      expre.add(argsIdent, newLit(paramIdx - 2))
      clr.add(expre)
    
    var overallParams = newLit(i - 1)

    let wrapper = quote do:
      proc `ffiIdent`*(argc: u4c, argv: ptr ByondValue, `sleepingProcIdent`: ByondValue): void {.cdecl, dynlib, exportc: `ffiNameStr`.} =
        let `argsIdent` = fromRawPartsToSeq(argv, argc.int, `overallParams`)
    
        try:
          `clr`

        except ByondCallError as err:
          discard callGlobalProc("byondapi_stack_trace".strId(), [ByondValue.init(err.cstrmsg)])

        except CatchableError as err:
          discard callGlobalProc("byondapi_stack_trace".strId(), [ByondValue.init(err.msg)])

    output.add(wrapper)

  result = newStmtList(output)
