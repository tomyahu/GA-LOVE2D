local class = require("love_ga_wrapper.lib.classes.class")
local extend = require("love_ga_wrapper.lib.classes.extend")
local InputGenomesFactory = require("love_ga_wrapper.lib.genetic_algorithms.genomes.factories.InputGenomesFactory")
local InputKeyIndividual = require("love_ga_wrapper.lib.genetic_algorithms.individuals.InputKeyIndividual")
local InputKeyFrameIndividual = require("love_ga_wrapper.lib.genetic_algorithms.individuals.InputKeyFrameIndividual")
local InputKeyFrameDurationIndividual = require("love_ga_wrapper.lib.genetic_algorithms.individuals.InputKeyFrameDurationIndividual")
local EphemeralKeyIndividual = require("love_ga_wrapper.lib.genetic_algorithms.individuals.EphemeralKeyIndividual")
-------------------------------------------------------------

-- class: InputIndividualFactory
-- param: word_dict:list(str) -> a list with the words corresponding to posible inputs
-- a factory class to create individuals of certain types
local InputIndividualFactory = class(function(self, word_dict)
    self.genome_factory = InputGenomesFactory.new(word_dict)
end)

-- getRandomNoInputEphemeralKeyIndividualWithFramesToTest: int(1,), float(0,1), int(1,) -> EphemeralKeyIndividual
-- Creates a new ephemeral key individual with null input given the frames to test, the ephemeral gene probability and the
-- max duration of the ephemeral genes.
-- This method in particular is created to tweak the number of genes created so that the expected value is equal to frames_to_test.
function InputIndividualFactory.getRandomNoInputEphemeralKeyIndividualWithFramesToTest(self, frames_to_test, ephemeral_stop_chance, max_frame_duration)
    local mid_frame_duration = max_frame_duration/2
    local size = math.floor(frames_to_test/(ephemeral_stop_chance*(mid_frame_duration - 1) + 1))
    
    return self:getRandomNoInputEphemeralKeyIndividual(size, ephemeral_stop_chance, max_frame_duration)
end

-- getRandomNoInputEphemeralKeyIndividual: int(1,), float(0,1), int(1,) -> EphemeralKeyIndividual
-- Creates a new ephemeral key individual with null input given the size, the ephemeral gene probability and the
-- max duration of the ephemeral genes.
function InputIndividualFactory.getRandomNoInputEphemeralKeyIndividual(self, size, ephemeral_stop_chance, max_frame_duration)
    local genomes = {}
    for i = 1,size do
        local random_genome = nil
        if ephemeral_stop_chance > math.random() then
            random_genome = self.genome_factory:getRandomNoInputEphemeralKeyGenome(max_frame_duration)
        else
            random_genome = self.genome_factory:getRandomSingleInputKeyGenome()
        end
        
        table.insert(genomes, random_genome)
    end
  
    return EphemeralKeyIndividual.new(genomes)
end

-- getRandomEphemeralKeyIndividualWithFramesToTest: int(1,), int(1,) -> EphemeralKeyIndividual
-- Creates a new ephemeral key individual with a number of random genomes equal to size.
-- This method in particular tweaks the maximum number of frames a gene can last acording to the frames to test,
-- so the expected value of frames the individual created used is equeal to the frames to test.
function InputIndividualFactory.getRandomEphemeralKeyIndividualWithFramesToTest(self, size, frames_to_test)
  return self:getRandomEphemeralKeyIndividual(size, math.floor(2*frames_to_test/size) + 1)
end

-- getRandomEphemeralKeyIndividual: int(1,), int(1,) -> EphemeralKeyIndividual
-- Creates a new ephemeral key individual with a number of random genes equal to size.
-- The number of frames of the ephemeral genes are limited by max_frames
function InputIndividualFactory.getRandomEphemeralKeyIndividual(self, size, max_frames)
  local genomes = {}
  for i = 1,size do
    local random_genome = self.genome_factory:getRandomEphemeralKeyGenome(max_frames)
    table.insert(genomes, random_genome)
  end
  
  return EphemeralKeyIndividual.new(genomes)
end

-- getRandomKeyFrameDurationIndividual: int(1,), int(1,), int(1,) -> InputKeyFrameDurationIndividual
-- creates a new key frame duration individual with a number of random genomes equal to size,
-- a max initial frame of max_frame and a max frame duration of max_duration.
function InputIndividualFactory.getRandomKeyFrameDurationIndividual(self, size, max_frame, max_duration)
  local genomes = {}
  for i = 1,size do
    local random_genome = self.genome_factory:getRandomKeyFrameDurationGenome(max_frame, max_duration)
    table.insert(genomes, random_genome)
  end

  return InputKeyFrameDurationIndividual.new(genomes)
end

-- getRandomKeyFrameIndividual: int(1,), int(1,) -> InputKeyFrameIndividual
-- creates a new key frame individual with a number of random genomes equal to size and a max frame of max_frame
function InputIndividualFactory.getRandomKeyFrameIndividual(self, size, max_frame)
  local genomes = {}
  for i = 1,size do
    local random_genome = self.genome_factory:getRandomKeyFrameGenome(max_frame)
    table.insert(genomes, random_genome)
  end

  return InputKeyFrameIndividual.new(genomes)
end

-- getRandomInputSingleKeyIndividual: int(1,) -> InputKeyIndividual
-- creates a new input key individual with a number of random genomes equal to size (number of frames to test)
function InputIndividualFactory.getRandomInputSingleKeyIndividual(self, size)
  local genomes = {}
  for i = 1,size do
    local random_genome = self.genome_factory:getRandomSingleInputKeyGenome()
    table.insert(genomes, random_genome)
  end
  
  return InputKeyIndividual.new(genomes)
end

-- getEmptyInputSingleKeyIndividual: int(1,) -> InputKeyIndividual
-- creates a new input key individual with a number of empty genomes equal to size (number of frames to test)
function InputIndividualFactory.getEmptyInputSingleKeyIndividual(self, size)
  local genomes = {}
  for i = 1,size do
    local empty_genome = self.genome_factory:getEmptySingleInputKeyGenome()
    table.insert(genomes, empty_genome)
  end
  
  return InputKeyIndividual.new(genomes)
end

-- setter
function InputIndividualFactory.setWordDict(self, new_word_dict)
    self.genome_factory:setInputDict(new_word_dict)
end

return InputIndividualFactory