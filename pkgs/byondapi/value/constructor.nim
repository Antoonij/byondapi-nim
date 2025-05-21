import value, ../strings, ../type_tag, ../../byondapi_raw/byondapi, ../error

proc new*(typ: type ByondValue): ByondValue = 
  ByondValue(xtype: NULL)

proc new*(typ: type ByondValue, str: string): ByondValue =
  result = ByondValue(xtype: STRING)
  result.setStr(str)

proc new*(typ: type ByondValue, value: cfloat): ByondValue =
  result = ByondValue(xtype: NUMBER)
  result.num = value

proc newObj*(typ: ByondValue, args: openarray[ByondValue]): ByondValue =
  result = ByondValue.new()
  let argCount = args.len.u4c
  let argPtr = if argCount > 0: addr args[0] else: nil

  if not Byond_New(addr typ, argPtr, argCount, addr result):
    raise newException(ByondCallError, "Failed to create new object of type.")

proc newList*(typ: type ByondValue): ByondValue =
  result = ByondValue.new(xtype: LIST)

  if not Byond_CreateList(addr result):
    raise newException(ByondCallError, "Failed to create list.")

proc newArglist*(typ: ByondValue, arglist: ByondValue): ByondValue =
  result = ByondValue.new()

  if not Byond_NewArglist(addr typ, addr arglist, addr result):
    raise newException(ByondCallError, "Failed to create new object of type using arglist.")
