local class = require("love_ga_wrapper.lib.classes.class")
local extend = require("love_ga_wrapper.lib.classes.extend")
local socket = require("socket")
local StepTASTester = require("love_ga_wrapper.lib.genetic_algorithms.testers.StepTASTester")
local TASInput = require("love_ga_wrapper.tas.TASInput")
-------------------------------------------------------------

-- class: MetricStepTASTester
-- param: frames_to_test:int -> the number of frames to test the individual
-- param: love_ga_wrapper:LoveGACreator -> the genetic algorithm wrapper
-- A tester for individuals that runs a step function every frame and finally returns the result from the main fitness
-- function.
-- The tester also registers and evaluates metrics given by the genetic algorithm wrapper in order to be compared later.
local MetricStepTASTester = extend(StepTASTester, function(self, frames_to_test, love_ga_wrapper)
end)

-- test: InputIndividual -> num
-- Returns the fitness value of the Input Individual given
function MetricStepTASTester.test(self, individual)
    self.love_ga_wrapper:resetGame()

    -- Get TAS from individual
    local tas = TASInput.new()
    tas:getInputsFromIndividual(individual)

    -- Set TAS to wrapper
    self.love_ga_wrapper:setTAS(tas)

    -- initialize fitness calculation
    local fitness_fun = self.love_ga_wrapper:getFitnessFun()
    fitness_fun:init(tas)

    -- initialize metrics
    local metric_manager = self.love_ga_wrapper:getMetricManager()
    local metrics = metric_manager:getMetrics()
    for _, metric in pairs(metrics) do
        metric:init(tas)
    end

    fitness_fun:stepFun()
    -- Run Update
    for i = 1, self.frames_to_test do
        self.love_ga_wrapper:runLoveCycle()
        self.love_ga_wrapper:letFramePass()
        fitness_fun:stepFun()

        for _, metric in pairs(metrics) do
            metric:stepFun()
        end
    end
    print("tested")

    for name, metric in pairs(metrics) do
        individual:addMetric(name, metric:mainFun())
    end

    return fitness_fun:mainFun()
end

return MetricStepTASTester