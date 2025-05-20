### ByondAPI-nim
Nim bindings for interacting with ByondAPI

### How to install?

# Bash
```bash
nimble install byondapi
```

# Git
```
git clone https://github.com/Antoonij/byondapi-nim.git
cd byondapi-nim
nimble install
```

### How to use?
```
import byondapi_macros/ffi # byondProc macro
import byondapi/value/lib # ByondValue definition/converters/constructors
import byondapi/procs, byondapi/strings, byondapi/vars, byondapi/threadsync

# That macros will create exported **procname**_ffi for all procs in macros body and unpack args into them. Non-existent args will be filled with null ByondValues. 
# Make sure you using **byond:** prefix in call_ext because byondProc can work only with ByondValues
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
