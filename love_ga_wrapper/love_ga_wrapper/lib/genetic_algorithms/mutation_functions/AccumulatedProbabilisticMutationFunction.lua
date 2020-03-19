local class = require("love_ga_wrapper.lib.classes.class")
local extend = require("love_ga_wrapper.lib.classes.extend")
local RegularMutationFunction =  require("love_ga_wrapper.lib.genetic_algorithms.mutation_functions.RegularMutationFunction")
--------------------------------------------------------------------------------------------------------

-- class: RegularMutationFunction
-- param: mutation_prob:int -> the probability of any indivual to mutate
-- Mutation Function class that mutates an individual many times until it stops given a mutation probability
local AccumulatedProbabilisticMutationFunction = extend(RegularMutationFunction, function(self, mutation_prob) end)

-- mutate: Individual -> None
-- mutates an individual given the function's probability. If the individual mutated then it can be mutated again.
-- If the individual didn't mutated then it returns. The expected amount of mutations for an individual is
-- 1/self.mutation_prob
function AccumulatedProbabilisticMutationFunction.mutate(self, individual)
    while math.random() < self.mutation_prob do
        individual:mutate()
    end
end

return AccumulatedProbabilisticMutationFunction
