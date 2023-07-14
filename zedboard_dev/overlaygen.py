#!/usr/bin/env python3

# This work ("Axolotl³²") is licensed under a Creative Commons
# Attribution-NonCommercial-ShareAlike 4.0 International License:
#
# https://creativecommons.org/licenses/by-nc-sa/4.0/

import coe

fd=open("overlay.txt")
lines=fd.readlines()
assert(len(lines) == 75)
data=[]
for line in lines:
	data += [ord(c) for c in line.replace(' ', '\0').replace('`', '\0').replace('\n', '\0').ljust(128, '\0')]
coe.write("RV32.srcs/sources_1/new/overlay.coe", data)
