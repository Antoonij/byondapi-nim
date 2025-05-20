# ByondAPI-nim
Nim bindings for interacting with ByondAPI.

Currently, not all bindings have been tested, so full functionality is not guaranteed.

# How to install?

### From Nimble
```bash
nimble install byondapi
```

### From Git
```bash
git clone https://github.com/Antoonij/byondapi-nim.git
cd byondapi-nim
nimble install
```

# How to use?
```
import byondapi_macros/ffi # byondProc macro
import byondapi/value/lib # ByondValue definition/converters/constructors
import byondapi/[procs, strings, vars, threadsync]

# This macro will create exported procs named `procname`_ffi for all procs in the body.
# The macro also unpacks arguments from BYOND into the original procs based on their parameters.
# Missing arguments will be replaced with null ByondValues.
# Make sure to use the `byond:` prefix in call_ext because byondProc works only with ByondValues.
byondProc:
  # Call from byond example: call_ext("dllfile.dll", "byond:meow_ffi")(your args)
  proc meow(sun: ByondValue, sin: ByondValue, nonexists: ByondValue): ByondValue =
    discard threadSync(
      proc(): ByondValue = 
        callGlobalProc("message_admins", [ByondValue.new("Hello from thread sync")])
    )

    discard callGlobalProc("message_admins", [ByondValue.new("start")])

    discard callGlobalProc("message_admins", [sun.readVar("name")])
    discard callGlobalProc("message_admins", [sin])

    let sinNum = sin.num()

    discard callGlobalProc("message_admins", [ByondValue.new(sinNum)])

    discard callGlobalProc("message_admins", [ByondValue.new("end")])
    discard callGlobalProc("message_admins", [nonexists])

    ByondValue.new()

  # Call from byond example: call_ext("dllfile.dll", "byond:secondExported_ffi")(your args)
  proc secondExported(): ByondValue = 
    ByondValue.new()
```

# How to compile your projects?
```bash
nimble c --cpu:i386 --app:lib --d:release path_to_nim_file.nim
```
