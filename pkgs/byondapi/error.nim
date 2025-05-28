import ../byondapi_raw/byondapi, std/options, ../byond_version

type
  ByondCallError* = object of CatchableError

when ByondVersion >= 516:
  proc crash*(message: string) = Byond_CRASH(message.cstring)

proc getLastError*(): Option[string] = 
  let str = Byond_LastError()

  if str.isNil:
    return none(string)

  some($str)

template handleByondError*(fn: untyped): untyped =
  block:
    let callResult = fn

    if not callResult:
      let lastErr = getLastError()

      raise newException(ByondCallError, if lastErr.isSome: lastErr.get() else: "Unknown error")
