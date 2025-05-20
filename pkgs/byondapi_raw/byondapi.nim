const
  DM64BIT* = when defined(amd64) or defined(arm64): true else: false

type
  u1c* = uint8
  s1c* = int8

  u2c* = uint16
  s2c* = int16
when DM64BIT:
  type
    u4c* = cuint
    s4c* = cint
else:
  type
    u4c* = culong
    s4c* = clong
type
  s8c* = clonglong
  u8c* = culonglong

  u4cOrPointer* {.union, bycopy.} = object
    num: u4c
    xptr {.importc: "ptr".}: pointer

const
  u1cMASK* = u1c(0xff)
  u2cMASK* = u2c(0xffff)
  u3cMASK* = u4c(0xffffff)
  u4cMASK* = u4c(0xffffffff)

  u1cMAX* = u1cMASK
  u2cMAX* = u2cMASK
  u3cMAX* = u3cMASK
  u4cMAX* = u4cMASK

  s1cMAX* = 0x7f'i8
  s1cMIN* = -0x7f'i8
  s2cMAX* = 0x7fff'i16
  s2cMIN* = -0x7fff'i16
  s4cMAX* = 0x7fffffff'i32
  s4cMIN* = -0x7fffffff'i32

  NONE* = u2cMAX
  NONE_U4C* = u4cMAX
  NOCH* = u1cMAX

const
  byondLib* = when defined(windows): "byondcore.dll"
              else: "libbyond.so"

type
  ByondValueType* = u1c

  ByondValueData* {.union, bycopy.} = object
    xref* {.importc: "ref".}: u4c
    num*: cfloat

  CByondValue* {.bycopy.} = object
    xtype* {.importc: "type".}: ByondValueType
    junk1*, junk2*, junk3*: u1c
    data*: ByondValueData

  CByondXYZ* {.bycopy.} = object
    x*, y*, z*: s2c
    junk*: s2c

  CByondPixLoc* {.bycopy.}= object
    x*, y*: cfloat
    z*: s2c
    junk*: s2c

  ByondCallback* =
    proc(data: pointer): CByondValue {.cdecl.}

const
    BYOND_TYPE_NULL* = u1c(0)
    BYOND_TYPE_NUMBER* = u1c(0x21)
    BYOND_TYPE_STRING* = u1c(0x04)
    BYOND_TYPE_LIST* = u1c(0x0F)
    BYOND_TYPE_MOB* = u1c(0x01)
    BYOND_TYPE_OBJ* = u1c(0x02)
    BYOND_TYPE_TURF* = u1c(0x03)
    BYOND_TYPE_AREA* = u1c(0x0D)
    BYOND_TYPE_CLIENT* = u1c(0x11)
    BYOND_TYPE_DBREF* = u1c(0x13)
    BYOND_TYPE_FILE* = u1c(0x17)
    BYOND_TYPE_IMAGE* = u1c(0x1A)
    BYOND_TYPE_FILTER* = u1c(0x1B)
    BYOND_TYPE_ICON_STATE* = u1c(0x1C)
    BYOND_TYPE_DATUM* = u1c(0x20)
    BYOND_TYPE_POINTER* = u1c(0x22)

{.push importc, dynlib: byondLib, cdecl.}

proc Byond_LastError*(): cstring

proc Byond_GetVersion*(version: var u4c, build: var u4c)

proc Byond_GetDMBVersion*(): u4c

proc ByondValue_Clear*(v: ptr CByondValue)

proc ByondValue_GetType*(v: ptr CByondValue): ByondValueType
  {.importc: "ByondValue_Type", dynlib: byondLib, cdecl.}

proc ByondValue_IsNull*(v: ptr CByondValue): bool

proc ByondValue_IsNum*(v: ptr CByondValue): bool

proc ByondValue_IsStr*(v: ptr CByondValue): bool

proc ByondValue_IsList*(v: ptr CByondValue): bool

proc ByondValue_IsTrue*(v: ptr CByondValue): bool

proc ByondValue_GetNum*(v: ptr CByondValue): cfloat

proc ByondValue_GetRef*(v: ptr CByondValue): u4c

proc ByondValue_SetNum*(v: ptr CByondValue, f: cfloat)

proc ByondValue_SetStr*(v: ptr CByondValue, str: cstring)

proc ByondValue_SetStrId*(v: ptr CByondValue, strid: u4c)

proc ByondValue_SetRef*(v: ptr CByondValue, typ: ByondValueType, refVal: u4c)

proc ByondValue_Equals*(a: ptr CByondValue, b: ptr CByondValue): bool

proc Byond_ThreadSync*(callback: ByondCallback, data: pointer, blockParam: bool): CByondValue

proc Byond_GetStrId*(str: cstring): u4c

proc Byond_AddGetStrId*(str: cstring): u4c

proc Byond_ReadVar*(loc: ptr CByondValue, varname: cstring, result: ptr CByondValue): bool

proc Byond_ReadVarByStrId*(loc: ptr CByondValue, varnameId: u4c, result: ptr CByondValue): bool

proc Byond_WriteVar*(loc: ptr CByondValue, varname: cstring, val: ptr CByondValue): bool

proc Byond_WriteVarByStrId*(loc: ptr CByondValue, varnameId: u4c, val: ptr CByondValue): bool

proc Byond_CreateList*(result: ptr CByondValue): bool

proc Byond_ReadList*(loc: ptr CByondValue, listItems: ptr CByondValue, len: var u4c): bool

proc Byond_WriteList*(loc: ptr CByondValue, listItems: ptr CByondValue, len: u4c): bool

proc Byond_ReadListAssoc*(loc: ptr CByondValue, listItems: ptr CByondValue, len: var u4c): bool

proc Byond_ReadListIndex*(loc: ptr CByondValue, idx: ptr CByondValue, result: ptr CByondValue): bool

proc Byond_WriteListIndex*(loc: ptr CByondValue, idx: ptr CByondValue, val: ptr CByondValue): bool

proc Byond_ReadPointer*(ptrVal: ptr CByondValue, result: ptr CByondValue): bool

proc Byond_WritePointer*(ptrVal: ptr CByondValue, val: ptr CByondValue): bool

proc Byond_CallProc*(src: ptr CByondValue, name: cstring, arg: ptr CByondValue, arg_count: u4c, result: ptr CByondValue): bool

proc Byond_CallProcByStrId*(src: ptr CByondValue, nameId: u4c, arg: ptr CByondValue, arg_count: u4c, result: ptr CByondValue): bool

proc Byond_CallGlobalProc*(name: cstring, arg: ptr CByondValue, arg_count: u4c, result: ptr CByondValue): bool

proc Byond_CallGlobalProcByStrId*(nameId: u4c, arg: ptr CByondValue, arg_count: u4c, result: ptr CByondValue): bool

proc Byond_ToString*(src: ptr CByondValue, buf: cstring, buflen: var u4c): bool

proc Byond_Block*(corner1: ptr CByondXYZ, corner2: ptr CByondXYZ, listItems: ptr CByondValue, len: var u4c): bool

proc Byond_Length*(src: ptr CByondValue, result: ptr CByondValue): bool

proc Byond_LocateIn*(typ: ptr CByondValue, listParam: ptr CByondValue, result: ptr CByondValue): bool

proc Byond_LocateXYZ*(xyz: ptr CByondXYZ, result: ptr CByondValue): bool

proc Byond_New*(typ: ptr CByondValue, arg: ptr CByondValue, arg_count: u4c, result: ptr CByondValue): bool

proc Byond_NewArglist*(typ: ptr CByondValue, arglist: ptr CByondValue, result: ptr CByondValue): bool

proc Byond_Refcount*(src: ptr CByondValue, result: ptr u4c): bool

proc Byond_GetXYZ*(src: ptr CByondValue, xyz: ptr CByondXYZ): bool
  {.importc: "Byond_XYZ", dynlib: byondLib, cdecl.}

proc Byond_GetPixLoc*(src: ptr CByondValue, pixloc: ptr CByondPixLoc): bool
  {.importc: "Byond_PixLoc", dynlib: byondLib, cdecl.}

proc Byond_BoundPixLoc*(src: ptr CByondValue, dir: u1c, pixloc: ptr CByondPixLoc): bool

proc ByondValue_IncRef*(src: ptr CByondValue)

proc ByondValue_DecRef*(src: ptr CByondValue)

proc ByondValue_DecTempRef*(src: ptr CByondValue)

proc Byond_TestRef*(src: ptr CByondValue): bool

proc Byond_CRASH*(message: cstring)

{.pop.}