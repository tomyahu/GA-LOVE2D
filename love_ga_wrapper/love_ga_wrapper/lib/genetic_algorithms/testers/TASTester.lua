local class = require("love_ga_wrapper.lib.classes.class")
local extend = require("love_ga_wrapper.lib.classes.extend")
local Tester = require("love_ga_wrapper.lib.genetic_algorithms.testers.Tester")
local TASInput = require("love_ga_wrapper.tas.TASInput")
-------------------------------------------------------------

-- class: TASTester
-- param: frames_to_test:int(0,) -> the amount of frames to test
-- param: love_ga_wrapper:LoveGACreator -> the genetic algorithm creator that runs over love to create an input script
-- A tester to get the fitness of individuals that represent an input script for a game
-- the tester just evaluates a fitness function given by the love wrapper when advancing
-- the specified amount of frames into the game
local TASTester = extend(Tester, function(self, frames_to_test, love_ga_wrapper)
    self.frames_to_test = frames_to_test
    self.love_ga_wrapper = love_ga_wrapper
end)

-- test: InputIndividual -> num
-- Returns the fitness value of the current input individual
function TASTester.test(self, individual)
    self.love_ga_wrapper:resetGame()
    collectgarbage("collect")
    local base_mem = collectgarbage("count")

    -- Get TAS from individual
    local tas = TASInput.new()
    tas:getInputsFromIndividual(individual)

    -- Set TAS to wrapper
    self.love_ga_wrapper:setTAS(tas)

    -- Run Update
    for i = 1, self.frames_to_test do
        self.love_ga_wrapper:runLoveCycle()
    end

    return self.love_ga_wrapper:getFitnessFunResult(base_mem)
end

return TASTester