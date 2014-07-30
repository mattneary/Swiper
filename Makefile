SHELL := /bin/bash
swift="/Applications/Xcode6-Beta4.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/swift"
lib: swiper/swiper.swift
	$(swift) -emit-module -module-name swiper swiper/swiper.swift

tests: lib swiperTests/tests.swift
	$(swift) -i <(cat swiper/swiper.swift swiperTests/tests.swift)

expr: lib expr.swift
	$(swift) -i <(cat swiper/swiper.swift expr.swift)

