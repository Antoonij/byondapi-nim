import ../../byondapi_raw/byondapi

type
    ByondValue* = CByondValue

proc isNull*(v: ByondValue): bool = ByondValue_IsNull(addr v)
proc isNum*(v: ByondValue): bool = ByondValue_IsNum(addr v)
proc isStr*(v: ByondValue): bool = ByondValue_IsStr(addr v)
proc isList*(v: ByondValue): bool = ByondValue_IsList(addr v)
proc isTrue*(v: ByondValue): bool = ByondValue_IsTrue(addr v)

proc num*(v: ByondValue): cfloat = ByondValue_GetNum(addr v)
proc `num=`*(v: var ByondValue, f: cfloat) = ByondValue_SetNum(addr v, f)

proc `ref`*(v: ByondValue): u4c = ByondValue_GetRef(addr v)
proc `ref=`*(v: var ByondValue, refVal: u4c) = ByondValue_SetRef(addr v, v.xtype, refVal)

proc `type`*(a: ByondValue): ByondValueType = ByondValue_GetType(addr a)

proc `==`*(a, b: ByondValue): bool = ByondValue_Equals(addr a, addr b)
proc `!=`*(a, b: ByondValue): bool = not ByondValue_Equals(addr a, addr b)

proc clear*(v: var ByondValue) = ByondValue_Clear(addr v)
