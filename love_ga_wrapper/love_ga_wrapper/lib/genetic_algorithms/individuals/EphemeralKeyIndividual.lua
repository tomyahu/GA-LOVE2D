local class = require("love_ga_wrapper.lib.classes.class")
local extend = require("love_ga_wrapper.lib.classes.extend")
local InputIndividual = require("love_ga_wrapper.lib.genetic_algorithms.individuals.InputIndividual")
local InputGenomesFactory = require("love_ga_wrapper.lib.genetic_algorithms.genomes.factories.InputGenomesFactory")
-------------------------------------------------------------

-- class: EphemeralKeyIndividual
-- param: genomes:list(SingleInputKeyGenome / EphemeralKeyGenome / NoInputEphemeralKeyGenome) -> The list of genomes of
--                          the current individual
-- An individual with ephemeral genomes and key frame genomes in the genetic algorithm
local EphemeralKeyIndividual = extend(InputIndividual, function(self, genomes)
    self.genome_factory = InputGenomesFactory.new(genomes[1]:getWordDict())
    
    local max_frame = 0
    for i = 1, (# genomes) do
        max_frame = max_frame + genomes[i]:getFrames()
    end
    self.max_frame = max_frame
end)

-- getInputsOnFrame: int(1,) -> dict(str,bool)
-- Gets this individual's inputs given a frame
function EphemeralKeyIndividual.getInputsOnFrame(self, frame)
    local current_frame = 1
    for _, genome in pairs(self.genomes) do
        current_frame = current_frame + genome:getFrames()
        if current_frame > frame then
            return genome:getInputs()
        end
    end
    return {}
end

-- getInputs: None -> list(dict(str, bool))
-- Gets the complete list of this individual's inputs
function EphemeralKeyIndividual.getInputs(self)
    local current_frame = 1
    local inputs = {}
    for i = 1, (# self.genomes) do
        local genome_frames = self.genomes[i]:getFrames()
        local genome_inputs = self.genomes[i]:getInputs()
        inputs[current_frame] = genome_inputs
        inputs[current_frame + genome_frames - 1] = {}
        for input, val in pairs(genome_inputs) do
            inputs[current_frame + genome_frames - 1][input] = not val
        end
        current_frame = current_frame + genome_frames
    end
    return inputs
end

-- getClass: None -> class
-- Returns the class of the Ephemeral Key Individual
function EphemeralKeyIndividual.getClass(self)
  return EphemeralKeyIndividual
end

-- getter
function EphemeralKeyIndividual.getMaxFrame(self)
    return self.max_frame
end

-- mutate: None -> None
-- Mutates a single random gene from the individual
function EphemeralKeyIndividual.mutate(self)
  local random_genome_index  = math.random(1, (# self.genomes))
  self.genomes[random_genome_index]:mutateWithMaxFrame(self:getMaxFrame())
end

return EphemeralKeyIndividual