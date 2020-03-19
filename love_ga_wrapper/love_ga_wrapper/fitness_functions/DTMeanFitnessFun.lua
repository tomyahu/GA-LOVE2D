local class = require("love_ga_wrapper.lib.classes.class")
local extend = require("love_ga_wrapper.lib.classes.extend")
local socket = require("socket")
local FitnessFun = require("love_ga_wrapper.fitness_functions.FitnessFun")
-------------------------------------------------------------

-- class: DTMeanFitnessFun
-- A fitness function thet calculates total time of all frames
local DTMeanFitnessFun = extend(FitnessFun, function(self)
    self.step_array = {}
end)

-- initAux: None -> None
-- The auxiliary initialization function for the fitness calculation
function DTMeanFitnessFun.initAux(self)
  self.start_time = socket.gettime()
  self.frame_num = 0
end

-- mainFun: None -> num
-- The main fitness function, sums all delta times
function DTMeanFitnessFun.mainFun(self)
  local delta_time = socket.gettime() - self.start_time 
  return delta_time
end

-- stepFun: LoveGACreator, any -> num
-- The step fitness function, updates framme num
function DTMeanFitnessFun.stepFun(self, love_ga_wrapper)
    self.frame_num = self.frame_num + 1
end

return DTMeanFitnessFun