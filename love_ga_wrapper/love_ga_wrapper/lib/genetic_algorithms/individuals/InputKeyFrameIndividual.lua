local class = require("love_ga_wrapper.lib.classes.class")
local extend = require("love_ga_wrapper.lib.classes.extend")
local InputIndividual = require("love_ga_wrapper.lib.genetic_algorithms.individuals.InputIndividual")
local InputGenomesFactory = require("love_ga_wrapper.lib.genetic_algorithms.genomes.factories.InputGenomesFactory")
local TablesMemoryLib = require("love_ga_wrapper.lib.memory.TablesMemoryLib")
--------------------------------------------------------------------------------------------------------

-- class: InputKeyFrameIndividual
-- param: genomes:list(KeyFrameGenome) -> The list of genomes of the curren individual
-- An individual with purely key frame genomes in the genetic algorithm
local InputKeyFrameIndividual = extend(InputIndividual, function(self, genomes)
    self.genome_factory = InputGenomesFactory.new(genomes[1]:getWordDict())
end,

function(genomes)
    table.sort(genomes, function(a, b) return a:getFrame() < b:getFrame() end)
    return InputIndividual.new(genomes)
end)

-- getInputsOnFrame: int(1,) -> dict(str,bool)
-- Gets this individual's inputs given a frame
function InputKeyFrameIndividual.getInputsOnFrame(self, frame)
    local inputs = self:getInputs()

    if not inputs[frame] then
        return {}
    else
        return inputs[frame]
    end
end

-- getInputs: None -> list(dict(str, bool))
-- Gets the complete list of this individual's inputs
function InputKeyFrameIndividual.getInputs(self)
    local inputs = {}
    for i = 1, (# self.genomes) do
        for frame, key in pairs(self.genomes[i]:getInputs()) do
            if not inputs[frame] then
                inputs[frame] = {}
            end

            if not inputs[frame+self.genomes[i]:getDuration()] then
                inputs[frame+self.genomes[i]:getDuration()] = {}
            end

            inputs[frame][key] = true
            inputs[frame+self.genomes[i]:getDuration()][key] = false
        end
    end
    return inputs
end

-- getMaxFrame: None -> int
-- gets the largest frame the individual has an input for
function InputKeyFrameIndividual.getMaxFrame(self)
    local max_frame = 0
    for i = 1, (# self.genomes) do
        max_frame = math.max(max_frame, self.genomes[i]:getFrame())
    end
    return max_frame
end

-- singlePointCrossOver: Individual -> Individual
-- Returns the result of a classic crossover between this individual and the passed individual
-- divides the genomes of both individuals in 2 (the ones that came before and after a random frame) and creates a new
-- individual with the first set of the first and the second of the second
function InputKeyFrameIndividual.singlePointCrossOver(self, individual)
    local max_frame_both_individuals = math.max(self:getMaxFrame(), individual:getMaxFrame())

    local new_genomes = {}
    local random_cut = math.random(1, max_frame_both_individuals)

    for i = 1, (# self.genomes) do
        if self.genomes[i]:getFrame() < random_cut then
            table.insert(new_genomes, TablesMemoryLib.copy(self.genomes[i]))
        end
    end

    for i = 1, (# individual.genomes) do
        if individual.genomes[i]:getFrame() >= random_cut then
            table.insert(new_genomes, TablesMemoryLib.copy(individual.genomes[i]))
        end
    end

    return self:getClass().new(new_genomes)
end

-- kPointCrossOver: Individual, int(1,) -> Individual
-- A generalization of the single point crossover, it generatess k random cuts in the individual's genomes (by random
-- frames) and intercalates the set of genomes of both individuals to create a new individual
function InputKeyFrameIndividual.kPointCrossOver(self, individual, k)
    local max_frame_both_individuals = math.max(self:getMaxFrame(), individual:getMaxFrame())

    local new_genomes = {}

    local random_cuts = {}

    table.insert(random_cuts, 0)
    for i = 1,k do
        table.insert(random_cuts, math.random(1, max_frame_both_individuals))
    end
    table.sort(random_cuts)
    table.insert(random_cuts, max_frame_both_individuals)

    local genomes_1 = self.genomes
    local genomes_2 = individual.genomes

    for i = 1, (# genomes_1) do
        local genome_frame = genomes_1[i]:getFrame()
        local condition = false

        for j = 2, (# random_cuts), 2 do
            if random_cuts[j-1] <= genome_frame and random_cuts[j] > genome_frame then
                condition = true
            end
        end

        if condition then
            table.insert(new_genomes, TablesMemoryLib.copy(genomes_1[i]))
        end
    end

    for i = 1, (# genomes_2) do
        local genome_frame = genomes_2[i]:getFrame()
        local condition = false

        for j = 3, (# random_cuts), 2 do
            if random_cuts[j-1] <= genome_frame and random_cuts[j] > genome_frame then
                condition = true
            end
        end

        if condition then
            table.insert(new_genomes, TablesMemoryLib.copy(genomes_2[i]))
        end
    end

    return self:getClass().new(new_genomes)
end

-- mutate: None -> None
-- Mutates a random gene of the individual using the individual's max frame
function InputKeyFrameIndividual.mutate(self)
    local random_genome_index  = math.random(1, (# self.genomes))
    local max_frame = self:getMaxFrame()
    self.genomes[random_genome_index]:mutateWithMaxFrame(max_frame)
end

-- deleteGenomesInFrame: int -> None
-- Deletes all genomes associated with a frame
function InputKeyFrameIndividual.deleteGenomesInFrame(self, frame)
    local genome_number = (# self.genomes)
    for i = genome_number, 1, -1 do
        if genome:getFrame() == frame then
            table.remove(self.genomes, i)
        end
    end
end

-- getClass: None -> class
-- Returns the class of the Input Key Frame Individual
function InputKeyFrameIndividual.getClass(self)
    return InputKeyFrameIndividual
end

return InputKeyFrameIndividual