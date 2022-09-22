#!/usr/bin/env lua

local here = arg[0]:match("(.*/)")
local inspect = require(here .. "inspect")
local simpleyaml = require("../src/simpleyaml")

local path = here .. "inputs/cmake-variants.yaml"
local variants = simpleyaml.parseFile(path)
print(inspect(variants))
