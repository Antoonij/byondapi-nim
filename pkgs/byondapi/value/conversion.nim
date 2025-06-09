import value, constructor

converter toCfloat*(src: ByondValue): cfloat =
    src.num

converter toByondValue*(src: cfloat): ByondValue =
    ByondValue.init(src)
