local class = require("love_ga_wrapper.lib.classes.class")
local extend = require("love_ga_wrapper.lib.classes.extend")

local MutationManager = require("love_ga_wrapper.lib.genetic_algorithms.population.managers.MutationManager")
local SelectionManager = require("love_ga_wrapper.lib.genetic_algorithms.population.managers.SelectionManager")
local CrossoverManager = require("love_ga_wrapper.lib.genetic_algorithms.population.managers.CrossoverManager")
-------------------------------------------------------------

-- class: Population
-- param: individuals:list(Individual) -> The initial individuals of the population
-- param: tester:Tester -> The tester of the problem to solve
-- param: elitism_ratio:num -> the ratio of individuals that'll pass to the next generation
-- The population of a genetic algorithm, implements all the methods that make the population reproduce
local Population = class(function(self, individuals, tester, elitism_ratio)
    self.individuals = individuals
    self.tester = tester
    self.mutation_manager = MutationManager.new()
    self.selection_manager = SelectionManager.new()
    self.crossover_manager = CrossoverManager.new()
    self.elitism_ratio = elitism_ratio

    self.individuals_fitness = {}
    for i=1,(# self.individuals) do
        table.insert(self.individuals_fitness, 0)
    end

    self.best_fitness = 0
    self.worst_fitness = 0
    self.best_individual = nil
    self.worst_individual = nil
end)

-- rankIndividuals: None -> None
-- Calculates the fitness of all individuals of the population and also
-- saves the best and worst individuals with their respective fitnesses
function Population.rankIndividuals(self)
    for i=1,(# self.individuals) do
        self.individuals_fitness[i] = self.tester:test(self.individuals[i])
    end

    local best_fitness = self.individuals_fitness[1]
    local worst_fitness = self.individuals_fitness[1]
    local best_individual = self.individuals[1]
    local worst_individual = self.individuals[1]

    for i=1,(# self.individuals) do
        if self.individuals_fitness[i] > best_fitness then
            best_fitness = self.individuals_fitness[i]
            best_individual = self.individuals[i]
        end

        if self.individuals_fitness[i] < worst_fitness then
            worst_fitness = self.individuals_fitness[i]
            worst_individual = self.individuals[i]
        end
    end

    self.best_fitness = best_fitness
    self.worst_fitness = worst_fitness
    self.best_individual = best_individual
    self.worst_individual = worst_individual
end

-- resetFitnessCalculation: None -> None
-- Resets the individual fitnesses and the best and worst individual and their fitnesses
function Population.resetFitnessCalculation(self)
    self.individuals_fitness = {}
    for i=1,(# self.individuals) do
        table.insert(self.individuals_fitness, 0)
    end

    self.best_fitness = 0
    self.worst_fitness = 0
    self.best_individual = nil
    self.worst_individual = nil
end

-- reproducePopulation: None -> None
-- Reproduces the population based on the calculated fitnesses and
-- updates the current population with the individuals of the next generation
function Population.reproducePopulation(self)
    local new_population = {}

    -- Applying elitism
    local elite_ids = self:getBestNIndividuals(math.floor((#self.individuals)*self.elitism_ratio))

    for _, i in pairs(elite_ids) do
        local p1 = self.individuals[i]
        table.insert(new_population, p1)
    end

    -- Create the children to pass to the next generation
    while (#new_population) < (#self.individuals) do
        local p1 = self.selection_manager:select(self)
        local p2 = self.selection_manager:select(self)

        local child = self.crossover_manager:crossOver(p1,p2)

        self.mutation_manager:mutate(child)

        table.insert(new_population, child)
    end

    -- Update the population
    self.individuals = new_population

end

-- getters
function Population.getBestIndividual(self)
    return self.best_individual
end

function Population.getMutationManager(self)
    return self.mutation_manager
end

function Population.getSelectionManager(self)
    return self.selection_manager
end

function Population.getCrossoverManager(self)
    return self.crossover_manager
end

-- getBestNIndividuals: int -> list(Individual)
-- Gets the n individuals with the most fitness in a list
function Population.getBestNIndividuals(self, n)
    local ordered_fitnesses = {}
    for i, fitness in pairs(self.individuals_fitness) do
        table.insert(ordered_fitnesses, {id=i, fitness=fitness})
    end
    table.sort(ordered_fitnesses, function(a,b) return a.fitness > b.fitness end)

    local best_n_ids = {}
    for i = 1, math.min((# ordered_fitnesses), n) do
        table.insert(best_n_ids, ordered_fitnesses[i].id)
    end

    return best_n_ids
end

function Population.getBestFitness(self)
    return self.best_fitness
end

function Population.getWorstFitness(self)
    return self.worst_fitness
end

function Population.getIndividuals(self)
    return self.individuals
end

function Population.getFitnesses(self)
    return self.individuals_fitness
end

return Population