local class = require("love_ga_wrapper.lib.classes.class")
local extend = require("love_ga_wrapper.lib.classes.extend")
local FitnessFun = require("love_ga_wrapper.fitness_functions.FitnessFun")
-------------------------------------------------------------

-- class: InverseFitnessFun
local InverseFitnessFun = extend(FitnessFun, function(self, fitness_fun)
    self.fitness_fun = fitness_fun
end)

-- init: TASInput -> None
function InverseFitnessFun.init(self, individual_tas)
    self.fitness_fun:init(individual_tas)
end

-- mainFun: None -> num
-- The main fitness function, gets the difference between the current and the asteroid number
function InverseFitnessFun.mainFun(self)
    return - self.fitness_fun:mainFun()
end

-- stepFun: None -> None
-- The step fitness function, does nothing
function InverseFitnessFun.stepFun(self)
    self.fitness_fun:stepFun()
end

return InverseFitnessFun