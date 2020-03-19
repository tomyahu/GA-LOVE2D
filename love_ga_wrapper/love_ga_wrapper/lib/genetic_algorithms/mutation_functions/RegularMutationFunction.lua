local class = require("love_ga_wrapper.lib.classes.class")
local extend = require("love_ga_wrapper.lib.classes.extend")
local MutationFunction =  require("love_ga_wrapper.lib.genetic_algorithms.mutation_functions.MutationFunction")
--------------------------------------------------------------------------------------------------------

-- class: RegularMutationFunction
-- param: mutation_prob:int -> the probability of any indivual to mutate
-- Mutation Function class that mutates an individual given a mutation probability
local RegularMutationFunction = extend(MutationFunction, function(self, mutation_prob)
    self.mutation_prob = mutation_prob
end)

-- mutate: Individual -> None
-- mutates an individual with the functions given probability
function RegularMutationFunction.mutate(self, individual)
    if math.random() < self.mutation_prob then
        individual:mutate()
    end
end

return RegularMutationFunction
