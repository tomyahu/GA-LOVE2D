local CharGenome = require("love_ga_wrapper.lib.genetic_algorithms.genomes.CharGenome")
local WordIndividual = require("love_ga_wrapper.lib.genetic_algorithms.individuals.WordIndividual")
local WordTester = require("love_ga_wrapper.lib.genetic_algorithms.testers.WordTester")
local PopulationFactory = require("love_ga_wrapper.lib.genetic_algorithms.population.PopulationFactory")

math.randomseed(os.time())

local population_num = 1000
local result_word = "helloworldhelloworldhelloworldhelloworldhelloworldhelloworldhelloworldhelloworldhelloworldhelloworld"
local mutation_prob = 0.001
local fitnesses_by_gen = {}


local result_word_len = (# result_word)
local tester = WordTester.new(result_word)

local word_dict = {"a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"," "}

function createRandomWordIndividual()
    local genomes = {}
    for i=1,result_word_len do
        table.insert(genomes, CharGenome.new(word_dict[ math.random(1, # word_dict) ]))
    end

    return WordIndividual.new(genomes)
end

local individuals = {}
for i=1,population_num do
    table.insert(individuals, createRandomWordIndividual())
end

local population = PopulationFactory.getClassicPopulation(individuals, tester, mutation_prob, 0.0)

i = 1
population:rankIndividuals()
print("Generation " .. tostring(i) .. "'s best: " .. population:getBestIndividual():getWord() .. " " .. population:getBestFitness())
while not (population:getBestIndividual():getWord() == result_word) do
    population:reproducePopulation()
    population:resetFitnessCalculation()
    i = i + 1
    population:rankIndividuals()
    print("Generation " .. tostring(i) .. "'s best: " .. population:getBestIndividual():getWord() .. " " .. population:getBestFitness())
end