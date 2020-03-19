local class = require("love_ga_wrapper.lib.classes.class")
local extend = require("love_ga_wrapper.lib.classes.extend")
local MutationFunction =  require("love_ga_wrapper.lib.genetic_algorithms.mutation_functions.MutationFunction")
--------------------------------------------------------------------------------------------------------

-- class: MutationManager
-- Manager class that manages the different mutation functions
local MutationManager = class(function(self)
    self.mutation_fun = MutationFunction.new()
end)

-- mutate: Individual -> None
-- mutates the individual based on the current mutation function
function MutationManager.mutate(self, individual)
    self.mutation_fun:mutate(individual)
end

-- setter
function MutationManager.setMutationFun(self, new_mutation_fun)
    self.mutation_fun =  new_mutation_fun
end

return MutationManager
