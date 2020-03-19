local class = require("love_ga_wrapper.lib.classes.class")
local extend = require("love_ga_wrapper.lib.classes.extend")
local SelectionFunction = require("love_ga_wrapper.lib.genetic_algorithms.selection_functions.SelectionFunction")
--------------------------------------------------------------------------------------------------------

-- class: TournamentSelectionFunction
-- param: size:int -> the number of participants in the tournament
-- Selection function that selects individuals using the tournament algorithm
local TournamentSelectionFunction = extend(SelectionFunction, function(self, size)
    self.size = size
end)

-- select: Population -> Individual
-- Selects an individual, it picks a number (given by self.size) of random individuals of the population and
-- picks the best of that set
function TournamentSelectionFunction.select(self, population)
    local individuals = population:getIndividuals()
    local individuals_fitness = population:getFitnesses()

    local individual_indexes = {}

    for i = 1,self.size do
        table.insert(individual_indexes, math.random((# individuals)))
    end

    local best_individual = individuals[individual_indexes[1]]
    local best_fitness = individuals_fitness[individual_indexes[1]]

    for i = 2, (# individual_indexes) do
        if individuals_fitness[individual_indexes[i]] > best_fitness then
            best_fitness = individuals_fitness[individual_indexes[i]]
            best_individual = individuals[individual_indexes[i]]
        end
    end

    return best_individual
end

return TournamentSelectionFunction
