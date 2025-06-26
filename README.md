# ByondAPI-nim
Nim bindings for interacting with ByondAPI.

[![Ask DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/Antoonij/byondapi-nim)

# How to install

```bash
git clone https://github.com/Antoonij/byondapi-nim.git
cd byondapi-nim
nimble install
```

and add dep to your .nimble file

```
requires "byondapi"
```

# How to use

```
import 
  byondapi_macros/ffi, # byondProc macro
  byondapi/value/lib, # ByondValue definition/converters/constructors
  byondapi/[global_proc, strings]

# Macro {.byondProc.} will create exported proc named `procname`_ffi.
# The macro also unpacks arguments from BYOND into the original procs based on their parameters.
# Missing arguments will be replaced with null ByondValues.
# Make sure to use the `byond:` prefix in call_ext because byondProc works only with ByondValues.
# Call from byond example: call_ext("file.dll/.so", "byond:meow_ffi")(your args)
proc meow(): ByondValue {.byondProc.} =
  ByondValue.init(1000 + 984)

# Call from byond example: call_ext("file.dll/.so", "byond:procCall_ffi")(your args)
# You also can use converters for less boilerplate
proc procCall(smth: cfloat, bomb: ByondValue): ByondValue {.byondProc.} =
  discard callGlobalProc("message_admins".strId, [ByondValue.init(smth)])
  discard callGlobalProc("message_admins".strId, [bomb.readVar("name".strId)])

  discard bomb.callProc("kaboom".strId, [])

  ByondValue.init(smth + 1)

# Same as byondProc, but first parameter should be sleeping proc
# Call from byond example: call_ext("file.dll/.so", "byond,await:secondExported_ffi")(your args)
proc secondExported(sleepy: ByondValue): void {.byondAsyncProc.} = 
  returnProc(sleepy, ByondValue.init(1984))
```

# How to compile your projects

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
