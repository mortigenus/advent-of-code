#!/bin/sh

cat AoC$1.playground/Sources/*.swift AoC$1.playground/Pages/Day$2.xcplaygroundpage/Contents.swift | swift - -- "cli" "AoC$1.playground/Pages/Day$2.xcplaygroundpage/"
