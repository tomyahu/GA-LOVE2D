local class = require("love_ga_wrapper.lib.classes.class")
local extend = require("love_ga_wrapper.lib.classes.extend")
local SelectionFunction = require("love_ga_wrapper.lib.genetic_algorithms.selection_functions.SelectionFunction")
--------------------------------------------------------------------------------------------------------

-- class: RouletteSelectionFunction
-- param: offset:num -> an offset number that is summed to all fitnesses to reduce standard deviation
-- Selection function that selects individuals using the roulette algorithm
local RouletteSelectionFunction = extend(SelectionFunction, function(self, offset)
    self.previous_individuals = {}
    self.reproduction_probs = nil

    self.offset = offset
end)

-- select: Population -> Individual
-- Selects an individual using the roulette algorithm, if the individuals' probabilities of reproduction has already
-- been calculated then it doesn't calculate it again
function RouletteSelectionFunction.select(self, population)
    local individuals = population:getIndividuals()

    -- recalculate reproduction probabilities if necesary
    if (self.previous_individuals ~= individuals) or (self.reproduction_probs == nil) then
        self:recalculateReproductionProbs(population)
        self.previous_individuals = individuals
    end

    local rand = math.random()
    local i = 1
    while rand > self.reproduction_probs[i] do
        rand = rand - self.reproduction_probs[i]
        i = i + 1
    end

    return individuals[i]
end

-- recalculateReproductionProbs: Population -> None
-- recalculates the current individuals' reproduction probabilities
function RouletteSelectionFunction.recalculateReproductionProbs(self, population)
    local individuals = population:getIndividuals()
    local individuals_fitness = population:getFitnesses()
    local worst_fitness = population:getWorstFitness()

    local offset = self.offset
    local total_points = 0

    for i=1,(# individuals) do
        total_points = total_points + (individuals_fitness[i] - worst_fitness + offset)
    end

    local reproducing_probs = {}

    for i=1,(# individuals) do
        table.insert(reproducing_probs, (individuals_fitness[i] - worst_fitness + offset)/total_points)
    end

    self.reproduction_probs = reproducing_probs
end

return RouletteSelectionFunction
