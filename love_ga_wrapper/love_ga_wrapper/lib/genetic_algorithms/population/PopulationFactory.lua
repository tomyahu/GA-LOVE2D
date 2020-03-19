local class = require("love_ga_wrapper.lib.classes.class")
local extend = require("love_ga_wrapper.lib.classes.extend")
local Population = require("love_ga_wrapper.lib.genetic_algorithms.population.Population")

-- Mutation Funs
local RegularMutationFunction =  require("love_ga_wrapper.lib.genetic_algorithms.mutation_functions.RegularMutationFunction")

-- Selection Funs
local TournamentSelectionFunction = require("love_ga_wrapper.lib.genetic_algorithms.selection_functions.TournamentSelectionFunction")

-- Crossover Funs
local SinglePointCrossoverFunction = require("love_ga_wrapper.lib.genetic_algorithms.crossover_functions.SinglePointCrossoverFunction")

--------------------------------------------------------------------------------------------------------

-- class: PopulationFactory
-- Factory class for creating populations
local PopulationFactory = class(function(self)
end)

-- getClassicPopulation: list(Individuals), Tester, float(0,1), float(0,1) -> Population
-- returns a classic population for genetic algorithms
function PopulationFactory.getClassicPopulation(individuals, tester, mutation_prob, elitism_ratio)
    local population = Population.new(individuals, tester, elitism_ratio)

    local mutation_manager = population:getMutationManager()
    mutation_manager:setMutationFun(RegularMutationFunction.new(mutation_prob))

    -- Tournament selection with tournaments of size 4
    local selection_manager = population:getSelectionManager()
    selection_manager:setSelectionFun(TournamentSelectionFunction.new(4))

    local crossover_manager = population:getCrossoverManager()
    crossover_manager:serCrossoverFun(SinglePointCrossoverFunction.new())

    return population
end

return PopulationFactory
