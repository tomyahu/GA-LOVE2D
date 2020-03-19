local class = require("love_ga_wrapper.lib.classes.class")
local extend = require("love_ga_wrapper.lib.classes.extend")
local NullGenome = require("love_ga_wrapper.lib.genetic_algorithms.genomes.NullGenome")
-------------------------------------------------------------

-- class: SingleInputKeyGenome
-- param: input:str -> the input key to press
-- param: word_dict:list(str) -> the word dictionary with all the possible inputs
-- A single input key genome, works similarly to the CharGenome but represents a key press for one frame
local SingleInputKeyGenome = extend(NullGenome, function(self, input, word_dict)
    self.input = input
    self.word_dict = word_dict
end)

-- crossOver: SingleInputKeyGenome -> SingleInputKeyGenome
-- Returns a new Int Genome with the mean of the both
function SingleInputKeyGenome.crossOver(self, genome)
  local new_input = ''
  
  if math.random() < 0.5 then
    new_input = self.input
  else
    new_input = genome.input
  end
  
  return SingleInputKeyGenome.new(new_input)
end

-- mutate: None -> None
-- Mutates the current genome
function SingleInputKeyGenome.mutate(self)
  self.input = self.word_dict[math.random(# self.word_dict)]
end

-- mutateWithMaxFrame: int -> None
-- Performs a regular mutation
function SingleInputKeyGenome.mutateWithMaxFrame(self, max_frame)
    self:mutate()
end

-- getter
function SingleInputKeyGenome.getInputs(self)
  local inputs = {}
  inputs[self.input] = true
  return inputs
end

-- getter
function SingleInputKeyGenome.getWordDict(self)
  return self.word_dict
end

-- getter
function SingleInputKeyGenome.getFrames(self)
    return 1
end


return SingleInputKeyGenome