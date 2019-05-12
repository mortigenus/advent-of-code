#!/bin/sh

cat AoC2018.playground/Sources/*.swift AoC2018.playground/Pages/Day$1.xcplaygroundpage/Contents.swift | swift - -- "cli" "AoC2018.playground/Pages/Day$1.xcplaygroundpage/"
