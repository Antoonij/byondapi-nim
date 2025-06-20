import ../byondapi_raw/byondapi, value/value

type
  CallbackData* = object
    cb*: proc(): ByondValue {.closure, gcsafe.}

proc trampoline*(data: pointer): ByondValue {.cdecl.} =
  let cd = cast[ptr CallbackData](data)
  result = cd.cb()

  dealloc(cd)

proc threadSync*(fn: proc(): ByondValue {.closure, gcsafe.};
                 blockParam = false): ByondValue =
  let cd = cast[ptr CallbackData](alloc0(sizeof(CallbackData)))
  cd.cb = fn

  let xptr = cast[pointer](cd)

  Byond_ThreadSync(trampoline, xptr, blockParam)
