local class = require("love_ga_wrapper.lib.classes.class")
local extend = require("love_ga_wrapper.lib.classes.extend")
local CrossoverFunction =  require("love_ga_wrapper.lib.genetic_algorithms.crossover_functions.CrossoverFunction")
--------------------------------------------------------------------------------------------------------

-- class: CrossoverManager
-- Manager class for crossover methods
local CrossoverManager = class(function(self)
    self.crossover_fun = CrossoverFunction.new()
end)

-- crossover: Individual, Individual -> Individual
-- applies the crossover function to the two individuals and returns a new individual
function CrossoverManager.crossOver(self, individual1, individual2)
    return self.crossover_fun:crossover(individual1, individual2)
end

-- setter
function CrossoverManager.serCrossoverFun(self, new_crossover_fun)
    self.crossover_fun = new_crossover_fun
end

return CrossoverManager
