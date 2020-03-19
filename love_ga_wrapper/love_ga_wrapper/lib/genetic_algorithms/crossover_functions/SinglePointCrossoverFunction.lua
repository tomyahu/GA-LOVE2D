local class = require("love_ga_wrapper.lib.classes.class")
local extend = require("love_ga_wrapper.lib.classes.extend")
local CrossoverFunction = require("love_ga_wrapper.lib.genetic_algorithms.crossover_functions.CrossoverFunction")
--------------------------------------------------------------------------------------------------------

-- class: CrossoverFunction
-- A Crossover Function class that uses single point crossover
local SinglePointCrossoverFunction = extend(CrossoverFunction, function(self)
    
end)

-- crossover: Individual, Individual -> None
-- returns the result of the first individual making single point crossover with the second
function SinglePointCrossoverFunction.crossover(self, individual1, individual2)
    return individual1:singlePointCrossOver(individual2)
end

return SinglePointCrossoverFunction
