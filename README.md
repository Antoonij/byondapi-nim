# ByondAPI-nim
Nim bindings for interacting with ByondAPI.

Currently, not all bindings have been tested, so full functionality is not guaranteed.

# How to install?

```bash
git clone https://github.com/Antoonij/byondapi-nim.git
cd byondapi-nim
nimble install
```

# How to use?
```
import 
  byondapi_macros/ffi, # byondProc macro
  byondapi/value/lib, # ByondValue definition/converters/constructors
  byondapi/[global_proc, threadsync]

# This macro will create exported procs named `procname`_ffi for all procs in the body.
# The macro also unpacks arguments from BYOND into the original procs based on their parameters.
# Missing arguments will be replaced with null ByondValues.
# Make sure to use the `byond:` prefix in call_ext because byondProc works only with ByondValues.
byondProc:
  # Call from byond example: call_ext("file.dll/.so", "byond:meow_ffi")(your args)
  proc meow(sun: ByondValue, sin: ByondValue, nonexists: ByondValue): ByondValue =
    discard threadSync(
      proc(): ByondValue = 
        callGlobalProc("message_admins", [ByondValue.init("Hello from thread sync")])
    )

    discard callGlobalProc("message_admins", [ByondValue.init("start")])

    discard callGlobalProc("message_admins", [sun.readVar("name")])
    discard callGlobalProc("message_admins", [sin])

    let sinNum = sin.num()

    discard callGlobalProc("message_admins", [ByondValue.init(sinNum)])

    discard callGlobalProc("message_admins", [ByondValue.init("end")])
    discard callGlobalProc("message_admins", [nonexists])

    ByondValue.init()

# Same as byondProc, but first parameter should be sleeping proc
byondAsyncProc:
  # Call from byond example: call_ext("file.dll/.so", "byond,await:secondExported_ffi")(your args)
  proc secondExported(sleepy: ByondValue, something: ByondValue): void = 
    returnProc(sleepy, ByondValue.init(1984))
```

# How to compile your projects?

### Windows target
```bash
nimble c --cpu:i386 --os:windows --app:lib --mm:arc -d:release path_to_nim_file.nim
```

### Linux target
```bash
nimble c --cpu:i386 --os:linux --app:lib --mm:arc -d:release path_to_nim_file.nim
```

### Additional compile defines

```bash
-d:ByondMajor=int
-d:ByondMinor=int
```

By default they will be set to latest API version (defined in byond_version.nim)

Do not compile with -d: debug, call conventions won't work

# Byond version < 516

Declare this proc

```
proc/byondapi_stack_trace(message)
	CRASH(message)
```
