import ../byondapi_raw/byondapi

type
  ByondCallError* = object of CatchableError

proc crash*(message: string) = Byond_CRASH(message.cstring)
