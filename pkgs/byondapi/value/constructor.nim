import value, ../type_tag, ../../byondapi_raw/byondapi, ../error, ../strings

proc init*(typ: type ByondValue): ByondValue = 
  ByondValue(xtype: BYOND_TYPE_NULL)

proc init*(typ: type ByondValue, str: cstring): ByondValue =
  result = ByondValue(xtype: BYOND_TYPE_STRING)
  
  result.setStr(str)

template init*(typ: type ByondValue, str: string): ByondValue =
  typ.init(str.cstring)

proc init*(typ: type ByondValue, boolval: bool): ByondValue =
  result = ByondValue(xtype: BYOND_TYPE_NUMBER)

  result.num = if boolval: 1 else: 0

proc init*(typ: type ByondValue, value: cfloat): ByondValue =
  result = ByondValue(xtype: BYOND_TYPE_NUMBER)

  result.num = value

proc init*(typ: type ByondValue, valueType: ByondValueType, reference: u4c): ByondValue =
  result = ByondValue(xtype: valueType)

  result.ref = reference

proc initList*(typ: type ByondValue): ByondValue =
  result = ByondValue.init(xtype: BYOND_TYPE_LIST)

  handleByondError(Byond_CreateList(addr result))

proc initObj*(typepath: ByondValue, args: openArray[ByondValue]): ByondValue =
  result = ByondValue.init()
  
  let argCount = args.len.u4c
  let argPtr = if argCount > 0: addr args[0] else: nil

  handleByondError(Byond_New(addr typepath, argPtr, argCount, addr result))

proc initFromArglist*(typepath: ByondValue, arglist: ByondValue): ByondValue =
  result = ByondValue.init()

  handleByondError(Byond_NewArglist(addr typepath, addr arglist, addr result))
