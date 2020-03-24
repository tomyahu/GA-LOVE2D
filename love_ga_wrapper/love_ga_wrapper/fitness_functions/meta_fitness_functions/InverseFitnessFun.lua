local class = require("love_ga_wrapper.lib.classes.class")
local extend = require("love_ga_wrapper.lib.classes.extend")
local FitnessFun = require("love_ga_wrapper.fitness_functions.FitnessFun")
-------------------------------------------------------------

-- class: InverseFitnessFun
-- param: fitness_fun:FitnessFun -> the fitness function to calculate the inverse of
-- a fitness function that takes other fitness function and calculates the multiplicative inverse of its value
local InverseFitnessFun = extend(FitnessFun, function(self, fitness_fun)
    self.fitness_fun = fitness_fun
end)

-- init: TASInput -> None
-- initializes the fitness function given
function InverseFitnessFun.init(self, individual_tas)
    self.fitness_fun:init(individual_tas)
end

-- mainFun: None -> num
-- The main fitness function, calculates the multiplicative inverse of the fitness function
function InverseFitnessFun.mainFun(self)
    return - self.fitness_fun:mainFun()
end

-- stepFun: None -> None
-- The step fitness function, calculates the fitness function step function
function InverseFitnessFun.stepFun(self)
    self.fitness_fun:stepFun()
end

return InverseFitnessFun