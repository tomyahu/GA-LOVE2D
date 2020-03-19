local class = require("love_ga_wrapper.lib.classes.class")
local extend = require("love_ga_wrapper.lib.classes.extend")
local TASTester = require("love_ga_wrapper.lib.genetic_algorithms.testers.TASTester")
local TASInput = require("love_ga_wrapper.tas.TASInput")
-------------------------------------------------------------

-- class: StepTASTester
-- param: frames_to_test:int -> the number of frames to test the individual
-- param: love_ga_wrapper:LoveGACreator -> the genetic algorithm wrapper
-- A tester for individuals that runs a step function every frame and finally returns the result from the main fitness
-- function
local StepTASTester = extend(TASTester, function(self, frames_to_test, love_ga_wrapper)
end)

-- test: InputIndividual -> num
-- Returns the fitness value of the Input Individual given
function StepTASTester.test(self, individual)
    self.love_ga_wrapper:resetGame()

    -- Get TAS from individual
    local tas = TASInput.new()
    tas:getInputsFromIndividual(individual)

    -- Set TAS to wrapper
    self.love_ga_wrapper:setTAS(tas)

    -- initialize fitness calculation
    local fitness_fun = self.love_ga_wrapper:getFitnessFun()
    fitness_fun:init(tas)

    fitness_fun:stepFun()
    -- Run Update
    for i = 1, self.frames_to_test do
        self.love_ga_wrapper:runLoveCycle()
        fitness_fun:stepFun()
    end

    return fitness_fun:mainFun()
end

return StepTASTester