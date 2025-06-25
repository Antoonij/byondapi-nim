import value, constructor, ../error, ../../byondapi_raw/byondapi

converter toCfloat*(src: ByondValue): cfloat {.inline.} =
    src.num

converter toByondValue*(src: cfloat): ByondValue {.inline.} =
    ByondValue.init(src)

converter toString*(src {.byref.}: ByondValue): string =
  if not src.isStr():
    raise newException(ByondCallError, "Cannot get string from non-string value.")

  var strbuf {.threadvar, global, gensym.}: seq[char]
  strbuf.setLen(1)

  var strbuflen = strbuf.len.u4c
  let callResult = Byond_ToString(addr src, cast[cstring](addr strbuf[0]), addr strbuflen)

  if not callResult and strbuflen > 0:
    strbuf.setLen(strbuflen.int + 1)
    handleByondError(Byond_ToString(addr src, cast[cstring](addr strbuf[0]), addr strbuflen))

  elif not callResult and strbuflen == 0:
    raise newException(ByondCallError, "ToString failed: returned 0 and error")
  
  strbuf.substr()
