import ../byondapi_raw/byondapi, value/value

type
  CallbackData* = object
    cb*: proc(): ByondValue {.closure, gcsafe.}

proc trampoline*(data: pointer): ByondValue {.cdecl.} =
  defer: deallocShared(data)
  let cd = cast[ptr CallbackData](data)
  
  result = cd.cb()

proc threadSync*(fn: proc(): ByondValue {.closure, gcsafe.};
                 blockParam = false): ByondValue =
  let cd = CallbackData.createSharedU()
  cd.cb = fn

  Byond_ThreadSync(trampoline, cd, blockParam)
