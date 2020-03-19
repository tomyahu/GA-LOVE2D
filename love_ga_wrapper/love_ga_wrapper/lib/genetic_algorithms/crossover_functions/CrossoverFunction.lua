local class = require("love_ga_wrapper.lib.classes.class")
local extend = require("love_ga_wrapper.lib.classes.extend")
--------------------------------------------------------------------------------------------------------

-- class: CrossoverFunction
-- An dummy class for crossover functions
local CrossoverFunction = class(function(self)
    
end)

-- crossover: Individual, Individual -> None
-- returns the first individual passed
function CrossoverFunction.crossover(self, individual1, individual2)
    return individual1
end

return CrossoverFunction
