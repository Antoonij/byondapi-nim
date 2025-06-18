import math

const
    ByondMajor {.intdefine.} = 516
    ByondMinor {.intdefine.} = 1664

    MinorVersionStr = $ByondMinor

    ByondVersion* = float(ByondMajor) + float(ByondMinor) / pow(10.0, float(MinorVersionStr.len))

template byond*(version: float, def: untyped): untyped = 
    when ByondVersion >= version:
        `def`
