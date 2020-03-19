local class = require("love_ga_wrapper.lib.classes.class")
local extend = require("love_ga_wrapper.lib.classes.extend")
local MinInputsMemoryFitnessFun = require("love_ga_wrapper.fitness_functions.MinInputsMemoryFitnessFun")
-------------------------------------------------------------

-- class: MaxInputsMemoryFitnessFun
-- A fitness function thet calculates total memory at the end of execution
local MaxInputsMemoryFitnessFun = extend(MinInputsMemoryFitnessFun, function(self)
end)

-- mainFun: None -> num
-- The main fitness function, gets the difference between the current memory and the initial memory
function MaxInputsMemoryFitnessFun.mainFun(self)
    return - MinInputsMemoryFitnessFun.mainFun(self)
end

return MaxInputsMemoryFitnessFun