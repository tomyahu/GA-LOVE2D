local class = require("love_ga_wrapper.lib.classes.class")
local extend = require("love_ga_wrapper.lib.classes.extend")
local FitnessFun = require("love_ga_wrapper.fitness_functions.FitnessFun")
-------------------------------------------------------------

-- class: SumFitnessFun
local SumFitnessFun = extend(FitnessFun, function(self, fitness_funs)
    self.fitness_funs = fitness_funs
end)

-- init: TASInput -> None
function SumFitnessFun.init(self, individual_tas)
    for _, fun in pairs(self.fitness_funs) do
        fun:init(individual_tas)
    end
end

-- mainFun: None -> num
-- The main fitness function, gets the difference between the current and the asteroid number
function SumFitnessFun.mainFun(self)
    local sum = 0
    
    for _, fun in pairs(self.fitness_funs) do
        sum = sum + fun:mainFun()
    end
    
    return - sum
end

-- stepFun: None -> None
-- The step fitness function, does nothing
function SumFitnessFun.stepFun(self)
    for _, fun in pairs(self.fitness_funs) do
        fun:stepFun()
    end
end

return SumFitnessFun