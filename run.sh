#!/bin/sh

cat AoC$2.playground/Sources/*.swift AoC$2.playground/Pages/Day$1.xcplaygroundpage/Contents.swift | swift - -- "cli" "AoC$2.playground/Pages/Day$1.xcplaygroundpage/"
