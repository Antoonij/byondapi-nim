import ../byondapi_raw/byondapi, value/value

type
  CallbackData* = ref object
    cb*: proc(): ByondValue {.closure, gcsafe.}

proc trampoline*(data: pointer): ByondValue {.cdecl.} =
  let cd = cast[CallbackData](data)
  cd.cb()

proc threadSync*(fn: proc(): ByondValue {.closure, gcsafe.};
                blockParam = false): ByondValue =
  let cd: owned CallbackData = CallbackData(cb: fn)
  let xptr = cast[pointer](cd)

  Byond_ThreadSync(trampoline, xptr, blockParam)
