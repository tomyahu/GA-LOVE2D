---------------------------------------------------------------------------------------------
local LoveGACreator = require("love_ga_wrapper.wrapper.LoveGACreator")
local FitnessFun = require("love_ga_wrapper.fitness_functions.MemoryFitnessFun")
local EphemeralKeyIndividualCreator = require("love_ga_wrapper.wrapper.ga_creator_managers.individual_creators.EphemeralKeyIndividualCreator")

local setted_seed = 1
local setted_dt = 1/12

local fitness_fun = FitnessFun.new()

local frames_to_skip = 710
local frames_to_test = 10
local generations = 10
local population_num = 100
local mutation_prob = 0.05
local elitism_ratio = 0.05
local export_path = "individuals/tes3.json"
local import_path = "individuals/test.json"

local input_list = {}
table.insert(input_list, "no_input")
table.insert(input_list, "space")
--table.insert(input_list, "s")
table.insert(input_list, "a")
table.insert(input_list, "d")
table.insert(input_list, "up")
table.insert(input_list, "down")
table.insert(input_list, "left")
table.insert(input_list, "right")

local metrics = {}
-- metrics["RAM Memory"] = FitnessFun.new()
local ga_creator = LoveGACreator.new(setted_dt, setted_seed, fitness_fun, input_list, true, metrics)

local individual_manager = ga_creator:getIndividualManager()
individual_manager:setIndividualCreator(EphemeralKeyIndividualCreator.new(80))

--print(love.graphics)

math.randomseed(setted_seed)
---------------------------------------------------------------------------------------------
require "game_main"
---------------------------------------------------------------------------------------------
ga_creator:init()

local m_thread = coroutine.create(function ()
    ga_creator:train(frames_to_test, generations, population_num, mutation_prob, elitism_ratio, export_path, frames_to_skip, import_path)
end)

function love.load()
end

function love.draw()
    local status, result = coroutine.resume(m_thread)

    if not status then
        print(result)
    end
end

function love.update()
end
---------------------------------------------------------------------------------------------