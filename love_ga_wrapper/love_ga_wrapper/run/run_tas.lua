---------------------------------------------------------------------------------------------
local LoveTASWrapper = require("love_ga_wrapper.wrapper.LoveTASWrapperTesterSkip")
local FitnessFun = require("love_ga_wrapper.fitness_functions.PlayerHighFitnessFun")

local setted_seed = 1
local setted_dt = 1/12
local input_script_path = "../individuals/" .. arg[3]
local frames_to_test = tonumber(arg[4])
local frames_to_skip = tonumber(arg[5])
local frames_to_yield_interval = tonumber(arg[6])
local fitness_fun = FitnessFun.new()

local metrics = {}


arg[3] = nil
arg[4] = nil
arg[5] = nil
arg[6] = nil

local tas_wrapper = LoveTASWrapper.new(setted_dt, setted_seed, input_script_path, fitness_fun, frames_to_test, frames_to_yield_interval, metrics, frames_to_skip)

math.randomseed(setted_seed)
function math.randomseed() end
---------------------------------------------------------------------------------------------
require "game_main"
---------------------------------------------------------------------------------------------
tas_wrapper:init()
---------------------------------------------------------------------------------------------