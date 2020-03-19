local class = require("love_ga_wrapper.lib.classes.class")
local extend = require("love_ga_wrapper.lib.classes.extend")
local NullGenome = require("love_ga_wrapper.lib.genetic_algorithms.genomes.NullGenome")
-------------------------------------------------------------

-- class: EphemeralKeyGenome
-- param: input:str -> the input key to press
-- param: frames:int(1,) -> the number of frames the actions will last
-- param: word_dict:list(str) -> the word dictionary with all the possible inputs
-- A genome that stores a certain key that was pressed for a number of frames
local EphemeralKeyGenome = extend(NullGenome, function(self, input, frames, word_dict)
    if frames < 1 then
      error("EphemeralKeyGenome's frame has to be an integer higher than 0")
    end
    
    self.input = input
    self.frame = frames
    self.word_dict = word_dict
end,

function(inputs, word_dict)
  return NullGenome.new()
end)

-- crossOver: EphemeralKeyGenome -> EphemeralKeyGenome
-- Throws an error, because individuals must implement this genome's crossover
function EphemeralKeyGenome.crossOver(self, genome)
  error("This genome cant do crossover with another genome, the crossover operation must be done between individuals.")
end

-- mutate: None -> None
-- Trows an error, because this genome has many possible mutation functions and individuals must implement a mutation
-- that decides which to use
function EphemeralKeyGenome.mutate(self)
  error("This genome has various mutation functions, thus the mutation operation must be done by individuals.")
end

-- dFrameMutation: int -> None
-- Varies the frame where the input was made
function EphemeralKeyGenome.dFrameMutation(self, df)
  local random_frame_delta = math.random(-df,df)
  self.frame = math.max(1, self.frame + random_frame_delta)
end

-- keyChangeMutation: None -> None
-- Changes the current input key to a random input
function EphemeralKeyGenome.keyChangeMutation(self)
  local word_dict_len = (# self.word_dict)
  local random_input = self.word_dict[math.random(1, word_dict_len)]
  self.input = random_input
end

-- mutateWithMaxFrame: int -> None
-- mutates the genome using an individual's largerst frame
-- performs a dFrame mutation and then it performs a keyChangeMutation
function EphemeralKeyGenome.mutateWithMaxFrame(self, max_frame)
    self:dFrameMutation(10)
    self:keyChangeMutation()
end

-- getter
function EphemeralKeyGenome.getInput(self)
    return self.input
end

-- getter
function EphemeralKeyGenome.getFrames(self)
    return self.frame
end

-- getter
function EphemeralKeyGenome.getWordDict(self)
    return self.word_dict
end

-- getter
function EphemeralKeyGenome.getInputs(self)
  local inputs = {}
  inputs[self.input] = true
  return inputs
end

return EphemeralKeyGenome