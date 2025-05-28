import math

const
    ByondMajor {.intdefine.} = 516
    ByondMinor {.intdefine.} = 1651

    MinorVersionStr = $ByondMinor

    ByondVersion* = float(ByondMajor) + float(ByondMinor) / pow(10.0, float(MinorVersionStr.len))
