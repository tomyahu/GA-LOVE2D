---------------------------------------------------------------------------------------------
local LoveTASWrapperFitnessTracked = require("love_ga_wrapper.wrapper.LoveTASWrapper")
local FitnessFun = require("love_ga_wrapper.fitness_functions.MinInputsMemoryFitnessFun")

local setted_seed = 1
local setted_dt = 1/12
local input_script_path = "../individuals/test"

local tas_wrapper = LoveTASWrapperFitnessTracked.new(setted_dt, setted_seed, input_script_path)

math.randomseed(setted_seed)
---------------------------------------------------------------------------------------------
require "game_main"
---------------------------------------------------------------------------------------------
tas_wrapper:init()
---------------------------------------------------------------------------------------------