local class = require("love_ga_wrapper.lib.classes.class")
local extend = require("love_ga_wrapper.lib.classes.extend")
local socket = require("socket")
local TablesMemoryLib = require("love_ga_wrapper.lib.memory.TablesMemoryLib")
local LoveWrapper = require("love_ga_wrapper.wrapper.LoveWrapper")
local MetricManager = require("love_ga_wrapper.wrapper.ga_creator_managers.MetricManager")
local TASInput = require("love_ga_wrapper.tas.TASInput")
local InputIndividualFactory = require("love_ga_wrapper.lib.genetic_algorithms.individuals.factories.InputIndividualFactory")
local PopulationFactory = require("love_ga_wrapper.lib.genetic_algorithms.population.PopulationFactory")
local PseudoJsonDictFile = require("love_ga_wrapper.lib.file.PseudoJsonDictFile")

local MetricStepTASTester = require("love_ga_wrapper.lib.genetic_algorithms.testers.MetricStepTASTester")
local EnvManager = require("love_ga_wrapper.lib.memory.EnvManager")
local LoveEnvLib = require("love_ga_wrapper.lib.memory.LoveEnvLib")

local IOLib = require("love_ga_wrapper.wrapper.wrapper_libs.IOLib")
local InputScriptLib = require("love_ga_wrapper.wrapper.wrapper_libs.InputScriptLib")

local IndividualManager = require("love_ga_wrapper.wrapper.ga_creator_managers.IndividualManager")
-------------------------------------------------------------

-- class: LoveGACreator
-- param: setted_dt:num -> the delta time that happens between each frame
-- param: setted_seed:num -> the seed of the random numbers to use
-- param: fitness_fun:function -> the fitness function to optimize
-- param: input_list:int -> the complete list of inputs the tas can use
-- param: run_draw:bool -> a boolean that tells the creator if it runs the draw function or it doesn't
-- param: metrics:dict(str,FitnessFun) -> a list of functions to use as metrics that will be printed in real time (the keys are the names to display)
-- A Genetic algorithm creator class that runs over LOVE2D, this version can run a script to get to a certain point in
-- a game to start testing
local LoveGACreator = extend(LoveWrapper,
    function(self, setted_dt, setted_seed, fitness_fun, input_list, run_draw, metrics)
        self.fitness_fun = fitness_fun
        self.input_list = input_list

        self.fitness_fun:setLoveGACreator(self)

        self.current_frame = 1
        self.last_update_dt = 0

        self.run_draw = run_draw

        self.update_function = function() end
        self.draw_function = function() end

        self.metric_manager = MetricManager.new(self)
        self.metric_manager:setMetrics(metrics)

        self.environment_manager = EnvManager.new()

        -- Set old global environment
        dofile "game_main.lua"
        local env_copy = TablesMemoryLib.copy(_G)
        self.environment_manager:addEnvironment("old_env", env_copy)

        self.individual_manager = IndividualManager.new(1, self)
        self.individual_manager:getIndividualCreator():setWordDict(self.input_list)

        self.skip_inputs = {}
        self.frames_to_skip = 0
    end)

-- train: int(1,), int(1,), int(1,), float(0,1), float(0,1), str -> None
-- applies the genetic algorithm with the hyper parameters provided, this method in particular uses an EnvStepTAS Tester
--    frames_to_test: number of frames to train the individuals
--    generations: number of generations to train the individuals
--    population_num: number of individuals of the population that will be generated
--    mutation_prob: probability of an individual to mutate
--    elitism_ratio: the ratio of the best individuals that will be passed intact to the next generation
--    export_path: the path of the file where the json that defines the best individual of the final generation will be
--      stored in the end
--    frames_to_skip: the number of frames to skip using inport_path's input script
--    import_path: the path of the file where the json that contains a TAS made to skip the first frames_to_skip number of frames
--      stored in the end
function LoveGACreator.train(self, frames_to_test, generations, population_num, mutation_prob, elitism_ratio, export_path, frames_to_skip, import_path)
    self.individual_manager:setFramesToTest(frames_to_test)

    -- Save import input script
    self.skip_inputs = IOLib.getInputsFromFile(import_path)
    self.frames_to_skip = frames_to_skip

    -- Declare Tester
    local tas_tester = MetricStepTASTester.new(frames_to_skip + frames_to_test, self)
    print("Tester Created")

    local best_individual = self:trainAux(frames_to_test, generations, population_num, mutation_prob, elitism_ratio, tas_tester)
    self:saveIndividualAsScriptWithFramesToSkip(best_individual, import_path, export_path, frames_to_skip)

    -- End Busy Waiting
    print("done")
    while true do end
    --love.event.quit( 0 )
end

-- trainAux: int(1,), int(1,), int(1,), float(0,1), float(0,1), TASTester -> None
-- Runs the whole genetic algorithm with the hyperparameters provided and the TASTester
--    frames_to_test: number of frames to train the individuals
--    generations: number of generations to train the individuals
--    population_num: number of individuals of the population that will be generated
--    mutation_prob: probability of an individual to mutate
--    elitism_ratio: the ratio of the best individuals that will be passed intact to the next generation
--    export_path: the path of the file where the json that defines the best individual of the final generation will be
--      stored in the end
--    tas_tester: the tester that will test the individuals to get their fitness in the genetic algorithm
function LoveGACreator.trainAux(self, frames_to_test, generations, population_num, mutation_prob, elitism_ratio, tas_tester)
    math.randomseed(socket.gettime())

    -- Create Individuals
    local individuals = {}
    for i = 1,population_num do
        table.insert(individuals, self.individual_manager:createRandomIndividual())
    end
    print("Wrapper: Individuals created.")

    -- Declare population
    local population = PopulationFactory.getClassicPopulation(individuals, tas_tester, mutation_prob, elitism_ratio)
    print("Population Created")

    -- Run GA
    population:rankIndividuals()
    print("Generation #1")
    print("Fitness: ", population:getBestFitness())
    for name, metric in pairs(population:getBestIndividual():getMetrics()) do
        print(name .. ":", metric)
    end
    print("")

    for i = 2, generations do
        math.randomseed(socket.gettime())
        population:reproducePopulation()
        population:resetFitnessCalculation()

        population:rankIndividuals()

        print("Generation #" .. tostring(i))
        print("Fitness: ", population:getBestFitness())
        for name, metric in pairs(population:getBestIndividual():getMetrics()) do
            print(name .. ":", metric)
        end
        print("")
    end

    -- Get best individual as TAS and return it
    return population:getBestIndividual()
end

-- saveIndividualAsScript: Individual, str, int, int -> None
-- Saves an individual as an input script in json format
function LoveGACreator.saveIndividualAsScriptWithFramesToSkip(self, individual, import_path, export_path, frames_to_skip)
    local best_inputs = individual:getInputs()
    local skip_inputs = IOLib.getInputsFromFile(import_path)

    local final_inputs = InputScriptLib.concatenateInputScripts(skip_inputs, best_inputs, frames_to_skip)

    print("Saving script")
    IOLib.saveInputsToFile(final_inputs, export_path)
end

-- resetGame: None -> None
-- auxiliary reset funcion for the wrapper
function LoveGACreator.resetGame(self)
    LoveGACreator.letFramePass()

    self.environment_manager:setEnvironmentCopy("old_env")
    for i, val in pairs(package.loaded) do
        print(i, val)
    end
    dofile "game_main.lua"
    love.load(arg)

    print("game_reseted")

    self:resetGameAux()
end

-- resetGameAux: None -> None
-- auxiliary reset funcion for the wrapper
function LoveGACreator.resetGameAux(self)
    LoveWrapper.resetGameAux(self)
    self.current_frame = 1
end

-- updateCurrentFrame: None -> None
-- updates the current frame count
function LoveGACreator.updateCurrentFrame(self)
    self.current_frame = self.current_frame + 1
end

-- runLoveCycle: None -> None
-- runs love's cycle once
function LoveGACreator.runLoveCycle(self)
    local start = socket.gettime()*1000
    self.update_function(self.last_update_dt)
    if self.run_draw then
        self.draw_function(self.last_update_dt)
    end
    self.last_update_dt = socket.gettime()*1000 - start
end

-- redefineLoveDraw: None -> None
-- redefines the love function love.graphics.draw
function LoveGACreator.redefineLoveDraw(self)
    if not self.draw_redefined then
        local old_draw = love.draw

        self.draw_function = function()
            old_draw()
        end
    end
end

-- redefineLoveUpdate: None -> None
-- redefines the love function love.keyboard.update
function LoveGACreator.redefineLoveUpdate(self)
    if not self.update_redefined then
        local old_update = love.update

        self.update_function = function(current_dt)
            self:setCurrentFrameDt(current_dt)

            local old_inputs = self.keys_pressed
            local tas_inputs = self.tas:getInputsFromFrame(self:getCurrentFrame())

            for input, state in pairs(tas_inputs) do
                if state then
                    if not old_inputs[input] then
                        self:pressKey(input)
                    end
                else
                    if old_inputs[input] then
                        self:releaseKey(input)
                    end
                end
            end

            self:updateCurrentFrame()
            local dt = self.setted_dt
            old_update(dt)
        end

        self.update_redefined = true
    end
end

-- letFramePass: None -> None
-- Lets a frame of the Love framework pass.
-- This process is very important because leaving a frame pass in the love framework means activating love's garbage
-- collector. This method is called everytime the game is restarted to free memory for the next fitness test. That way
-- the memory from the game's variables are cleaned and also between generations the individuals of the previous
-- generation are cleaned of the memory as well.
--
-- When testing large amounts of frames you may want to use (or make) a tester that calls this method more often to
-- free memory while the game is running.
--
-- To simulate the real game's execution this method should be called every frame that passed. That is kind of not very
-- efficient and the program will be slower (thats the cost of doing that).
function LoveGACreator.letFramePass()
    coroutine.yield()
end

-- setters
function LoveGACreator.setRunDraw(self, new_run_draw)
    self.run_draw = new_run_draw
end

-- setTAS: TASInput -> None
-- sets the current tas and saves a copy of the inputs the tas is setted in case the game crashes
function LoveGACreator.setTAS(self, tas)
    self.tas = tas

    local inputs = tas:getInputs()
    local final_inputs = InputScriptLib.concatenateInputScripts(self.skip_inputs, inputs, self.frames_to_skip)

    self.tas:setInputs(final_inputs)

    IOLib.saveInputsToFile(final_inputs, "individuals/aux_input_script")
end

-- getters
function LoveGACreator.getRunDraw(self)
    return self.run_draw
end

function LoveGACreator.getMetricManager(self)
    return self.metric_manager
end

function LoveGACreator.getIndividualManager(self)
    return self.individual_manager
end

function LoveGACreator.getFitnessFun(self)
    return self.fitness_fun
end

function LoveGACreator.getInputList(self)
    return self.input_list
end

-- getCurrentFrame: None -> int
-- returns the current frame of the wrapper
function LoveGACreator.getCurrentFrame(self)
    return self.current_frame
end

return LoveGACreator