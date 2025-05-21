import ../../byondapi_raw/byondapi

type
    ByondValue* = CByondValue

proc isNull*(v {.byref.}: ByondValue): bool = ByondValue_IsNull(addr v)
proc isNum*(v {.byref.}: ByondValue): bool = ByondValue_IsNum(addr v)
proc isStr*(v {.byref.}: ByondValue): bool = ByondValue_IsStr(addr v)
proc isList*(v {.byref.}: ByondValue): bool = ByondValue_IsList(addr v)
proc isTrue*(v {.byref.}: ByondValue): bool = ByondValue_IsTrue(addr v)

proc num*(v {.byref.}: ByondValue): cfloat = ByondValue_GetNum(addr v)
proc `num=`*(v: var ByondValue, f: cfloat) = ByondValue_SetNum(addr v, f)

proc `ref`*(v {.byref.}: ByondValue): u4c = ByondValue_GetRef(addr v)
proc `ref=`*(v: var ByondValue, refVal: u4c) = ByondValue_SetRef(addr v, v.xtype, refVal)

proc `type`*(a {.byref.}: ByondValue): ByondValueType = ByondValue_GetType(addr a)

proc `==`*(a {.byref.}: ByondValue, b: ByondValue): bool = ByondValue_Equals(addr a, addr b)
proc `!=`*(a {.byref.}: ByondValue, b: ByondValue): bool = not ByondValue_Equals(addr a, addr b)

proc clear*(v: var ByondValue) = ByondValue_Clear(addr v)
