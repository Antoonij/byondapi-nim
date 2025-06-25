import ../../byondapi_raw/byondapi, ../../byond_version

type
    ByondValue* = CByondValue

proc isNull*(v {.byref.}: ByondValue): bool {.inline.} = 
  ByondValue_IsNull(addr v)

proc isNum*(v {.byref.}: ByondValue): bool {.inline.} = 
  ByondValue_IsNum(addr v)

proc isStr*(v {.byref.}: ByondValue): bool {.inline.} = 
  ByondValue_IsStr(addr v)

proc isList*(v {.byref.}: ByondValue): bool {.inline.} = 
  ByondValue_IsList(addr v)

proc isTrue*(v {.byref.}: ByondValue): bool {.inline.} = 
  ByondValue_IsTrue(addr v)

proc isType*(src {.byref.}: ByondValue, typestr: cstring): bool {.byond(516.1664), inline.} = 
  ByondValue_IsType(addr src, typestr)

template isType*(src: ByondValue, typestr: string): bool {.byond(516.1664).} = 
  isType(src, typestr.cstring)

proc num*(v {.byref.}: ByondValue): cfloat {.inline.} = 
  ByondValue_GetNum(addr v)

proc `num=`*(v: var ByondValue, f: cfloat) {.inline.} = 
  ByondValue_SetNum(addr v, f)

proc `ref`*(v {.byref.}: ByondValue): u4c {.inline.} = 
  ByondValue_GetRef(addr v)

proc `ref=`*(v: var ByondValue, refVal: u4c) {.inline.} = 
  ByondValue_SetRef(addr v, v.xtype, refVal)

proc `type`*(a {.byref.}: ByondValue): ByondValueType {.inline.} = 
  ByondValue_GetType(addr a)

proc `==`*(a {.byref.}: ByondValue, b: ByondValue): bool {.inline.} = 
  ByondValue_Equals(addr a, addr b)

proc `!=`*(a {.byref.}: ByondValue, b: ByondValue): bool {.inline.} = 
  not ByondValue_Equals(addr a, addr b)

proc clear*(v: var ByondValue) {.inline.} = 
  ByondValue_Clear(addr v)
