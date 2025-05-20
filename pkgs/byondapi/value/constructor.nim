import value, ../strings, ../type_tag, ../../byondapi_raw/byondapi

proc new*(typ: type ByondValue): ByondValue = 
  ByondValue(xtype: NULL)

proc new*(typ: type ByondValue, str: string): ByondValue =
  result = ByondValue(xtype: STRING)
  result.setStr(str)

proc new*(typ: type ByondValue, value: cfloat): ByondValue =
  result = ByondValue(xtype: NUMBER)
  result.num = value

proc newObj*(typ: type ByondValue, args: openarray[ByondValue]): ByondValue =
  var res: ByondValue = ByondValue.new()
  let argCount = args.len.u4c
  let argPtr = if argCount > 0: addr args[0] else: nil

  if not Byond_New(addr typ, argPtr, argCount, addr res):
    raise newException(ByondCallError, "Failed to create new object of type.")

  return res

proc newList*(typ: type ByondValue): ByondValue =
  var res: ByondValue = ByondValue.new()

  if not Byond_CreateList(addr res):
    raise newException(ByondCallError, "Failed to create list.")
  
  res.xtype = LIST

  return res
