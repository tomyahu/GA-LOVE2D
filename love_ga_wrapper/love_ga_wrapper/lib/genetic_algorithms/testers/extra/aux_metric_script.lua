local LoveTASWrapperFitnessTracked = require("love_ga_wrapper.wrapper.LoveTASWrapper")
local ga_settings = require("love_ga_wrapper.run.ga_settings")
---------------------------------------------------------------------------------------------

local setted_seed = ga_settings.setted_seed
local setted_dt = ga_settings.setted_dt
local fitness_fun = ga_settings.fitness_fun

local input_script_path = "individuals/aux_input_script"

local tas_wrapper = LoveTASWrapperFitnessTracked.new(setted_dt, setted_seed, input_script_path)

math.randomseed(setted_seed)
---------------------------------------------------------------------------------------------
require "game_main"
---------------------------------------------------------------------------------------------
tas_wrapper:init()
---------------------------------------------------------------------------------------------

fitness_fun:init(tas_wrapper:getTAS())

-- TODO: Run for frames to skip and frames to test
--fitness_fun:stepFun()
--for i=1,frames_to_test do
--  love.update(setted_dt)
--  love.draw(setted_dt)
--  fitness_fun:stepFun()
--  coroutine.yield()
--end

-- TODO: Return Fitness
-- return fitness_fun:mainFun()