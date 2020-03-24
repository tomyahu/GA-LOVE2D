local class = require("love_ga_wrapper.lib.classes.class")
local extend = require("love_ga_wrapper.lib.classes.extend")
local FitnessFun = require("love_ga_wrapper.fitness_functions.FitnessFun")
-------------------------------------------------------------

-- class: MemoryFitnessFun
-- A fitness function thet calculates total memory at the end of execution
local MemoryFitnessFun = extend(FitnessFun, function(self)
    self.initial_memory = 0
end)

-- initAux: None -> None
-- The auxiliary initialization function for the fitness calculation, gets the current memory used
function MemoryFitnessFun.initAux(self)
  collectgarbage("collect")
  self.initial_memory = collectgarbage("count")
end

-- mainFun: None -> num
-- The main fitness function, gets the difference between the current memory and the initial memory
function MemoryFitnessFun.mainFun(self)
  collectgarbage("collect")
  local current_memory = collectgarbage("count")
  return (current_memory - self.initial_memory)
end

-- stepFun: None -> None
-- The step fitness function, does nothing
function MemoryFitnessFun.stepFun(self)
end

return MemoryFitnessFun