local class = require("love_ga_wrapper.lib.classes.class")
local extend = require("love_ga_wrapper.lib.classes.extend")
local InputKeyFrameIndividual = require("love_ga_wrapper.lib.genetic_algorithms.individuals.InputKeyFrameIndividual")
local InputGenomesFactory = require("love_ga_wrapper.lib.genetic_algorithms.genomes.factories.InputGenomesFactory")
--------------------------------------------------------------------------------------------------------

-- class: InputKeyFrameDurationIndividual
-- param: genomes:list(KeyFrameDurationGenome) -> The list of genomes of the curren individual
-- An individual with key frame duration genomes in the genetic algorithm
local InputKeyFrameDurationIndividual = extend(InputKeyFrameIndividual, function(self, genomes)
    self.inputs = nil
    self.genome_factory = InputGenomesFactory.new(genomes[1]:getWordDict())
end,

function(genomes)
    table.sort(genomes, function(a, b) return a:getFrame() < b:getFrame() end)
    return Individual.new(genomes)
end)

-- mutate: None -> None
-- Mutates a random gene of the individual using the individual's largest frame
function InputKeyFrameDurationIndividual.mutate(self)
    local random_genome_index  = math.random(1, (# self.genomes))
    local max_frame = self:getMaxFrame()
    self.genomes[random_genome_index]:mutateWithMaxFrame(max_frame)
end

-- getClass: None -> class
-- Returns the class of the Input Key Frame Duration Individual
function InputKeyFrameDurationIndividual.getClass(self)
    return InputKeyFrameDurationIndividual
end

return InputKeyFrameIndividual