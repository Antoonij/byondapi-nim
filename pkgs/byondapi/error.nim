import ../byondapi_raw/byondapi, std/options, ../byond_version

type
  ByondCallError* = object of CatchableError
    cstrmsg*: cstring

proc crash*(message: string) {.byond(516).} = Byond_CRASH(message.cstring)

proc getLastError*(): Option[cstring] = 
  let str = Byond_LastError()

  if str.isNil:
    return none(cstring)

  some(str)

template newException*(exceptn: type ByondCallError, message: cstring;
                       parentException: ref Exception = nil): untyped =
  (ref exceptn)(cstrmsg: message, parent: parentException)

template newException*(exceptn: type ByondCallError, message: string;
                       parentException: ref Exception = nil): untyped =
  (ref exceptn)(cstrmsg: message.cstring, parent: parentException)

template handleByondError*(fn: untyped): untyped =
  let callResult {.gensym.} = `fn`

  if not callResult:
    let lastErr {.gensym.} = getLastError()

    raise newException(ByondCallError, if lastErr.isSome(): lastErr.get() else: "Unknown error".cstring)
