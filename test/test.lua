#!/usr/bin/env lua

local here = arg[0]:match("(.*/)")
local inspect = require(here .. "inspect")
local simpleyaml = require("../src/simpleyaml")

local function test(file)
  local path = here .. "inputs/" .. file
  local parsed = simpleyaml.parse_file(path)
  print(inspect(parsed))
end

test("cmake-variants.yaml")
test("example.yaml")
