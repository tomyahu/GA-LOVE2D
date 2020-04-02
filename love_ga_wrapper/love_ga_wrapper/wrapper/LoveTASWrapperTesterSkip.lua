local class = require("love_ga_wrapper.lib.classes.class")
local extend = require("love_ga_wrapper.lib.classes.extend")
local json = require("love_ga_wrapper.lib.file.pseudo_json.pseudo_json")
local LoveTASWrapper = require("love_ga_wrapper.wrapper.LoveTASWrapper")
local LoveTASWrapperTester = require("love_ga_wrapper.wrapper.LoveTASWrapperTester")
--------------------------------------------------------------------------------------------------------

-- class: LoveTASWrapperTesterSkip
-- param: setted_dt:num -> the delta time that happens between each frame
-- param: setted_seed:num -> the seed of the random numbers to use
-- param: tas_path:str -> the path of the input sequence
-- param: fitness_function:FitnessFun -> the fitness function to compute
-- param: frames_to_test:int -> the amount of frames to run the input sequence computing the function
-- param: frames_yield_interval:int -> the amount of frames to run a frame in love
-- param: metrics:list(FitnessFun) -> the list of metrics to compute with the fitness function
-- param: frames_to_skip:int -> the amount of frames to run the input sequence without computing the function at the beggining
-- The wrapper that runs an input sequence for a number of frames to skip and test and computes the fitness function
-- and a list of metrics
local LoveTASWrapperTesterSkip = extend(LoveTASWrapperTester, function(self, setted_dt, setted_seed, tas_path, fitness_function, frames_to_test, frames_yield_interval, metrics, frames_to_skip)
    self.fitness_fun = fitness_function
    self.fitness_fun:setLoveWrapper(self)
    self.metrics = metrics

    self.frames_to_skip = frames_to_skip
end)

-- init: None -> None
-- Initializes the wrapper, redefines the love functions
function LoveTASWrapperTesterSkip.init(self)
    LoveTASWrapper.init(self)

    self.m_thread = coroutine.create(function()
        self.load_function(arg)
        for i = 1, self.frames_to_skip do
            if self.frames_yield_interval > 0 then
                if i % self.frames_yield_interval == 0 then
                    self.letFramePass()
                end
            end
            self:runLoveCycle()
        end

        self.fitness_fun:init()
        for _, metric_fun in pairs(self.metrics) do
            metric_fun:init()
        end
        for i = 1, self.frames_to_test do
            if self.frames_yield_interval > 0 then
                if i % self.frames_yield_interval == 0 then
                    self.letFramePass()
                end
            end

            self.fitness_fun:stepFun()
            for _, metric_fun in pairs(self.metrics) do
                metric_fun:stepFun()
            end

            self:runLoveCycle()
        end

        self.fitness_fun:stepFun()
        for _, metric_fun in pairs(self.metrics) do
    		metric_fun:stepFun()
    	end

		output_dict = {}
		output_dict["fitness"] = self.fitness_fun:mainFun()

		output_dict["metrics"] = {}
		for metric_name, metric_fun in pairs(self.metrics) do
    		output_dict["metrics"][metric_name] = metric_fun:mainFun()
    	end

        io.stdout:write(json.encode(output_dict))
        love.event.quit()
    end)
end

return LoveTASWrapperTesterSkip
