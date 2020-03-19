local class = require("love_ga_wrapper.lib.classes.class")
local extend = require("love_ga_wrapper.lib.classes.extend")
local NullGenome = require("love_ga_wrapper.lib.genetic_algorithms.genomes.NullGenome")
-------------------------------------------------------------

-- class: KeyFrameGenome
-- param: input:str -> the input key to press
-- param: frame:int(1,) -> the frame where to press the input
-- param: word_dict:list(str) -> the word dictionary with all the possible inputs
-- A genome that stores a certain key that was pressed on a certain frame for one frame
local KeyFrameGenome = extend(NullGenome, function(self, input, frame, word_dict)
    if frame < 1 then
      error("KeyFrameGenome's frame has to be an integer higher than 0")
    end
    
    self.input = input
    self.frame = frame
    self.active = true
    self.word_dict = word_dict
end,

function(inputs, word_dict)
  return NullGenome.new()
end)

-- crossOver: KeyFrameGenome -> KeyFrameGenome
-- Throws an error, because individuals must implement this genome's crossover
function KeyFrameGenome.crossOver(self, genome)
  error("This genome cant do crossover with another genome, the crossover operation must be done between individuals.")
end

-- mutate: None -> None
-- Trows an error, because this genome has many possible mutation functions and individuals must implement a mutation
-- that decides which to use
function KeyFrameGenome.mutate(self)
  error("This genome has various mutation functions, thus the mutation operation must be done by individuals.")
end

-- dFrameMutation: int -> None
-- Varies the frame where the input was made
function KeyFrameGenome.dFrameMutation(self, df)
  local random_frame_delta = math.random(-df,df)
  self.frame = math.max(0, self.frame + random_frame_delta)
end

-- keyChangeMutation: None -> None
-- Changes the current input key to a random input
function KeyFrameGenome.keyChangeMutation(self)
  local word_dict_len = (# self.word_dict)
  local random_input = self.word_dict[math.random(1, word_dict_len)]
  self.input = random_input
end

-- mutateWithMaxFrame: int -> None
-- Performs a mutation using an individual's largest frame
-- it performs a dFrame mutation, sets the frame to the set given by max frame
-- and finally it performs a keyChange mutation
function KeyFrameGenome.mutateWithMaxFrame(self, max_frame)
    self:dFrameMutation(10)
    self.frame = math.min(self.frame, max_frame)
    
    self:keyChangeMutation()
end

-- activate: None -> None
-- Activates the gene
function KeyFrameGenome.activate(self)
  self.active = true
end

-- deactivate: None -> None
-- Deactivates the gene
function KeyFrameGenome.deactivate(self)
  self.active = false
end

-- isActive: None -> None
-- Checks if gene is active
function KeyFrameGenome.isActive(self)
  return self.active
end

-- getter
function KeyFrameGenome.getInputs(self)
  local inputs = {}
  
  if self.active then
    inputs[self.frame] = self.input
  end
  
  return inputs
end

-- getter
function KeyFrameGenome.getFrame(self)
    return self.frame
end

-- getter
function KeyFrameGenome.getWordDict(self)
    return self.word_dict
end

-- getter
function KeyFrameGenome.getDuration(self)
    return 1
end

return KeyFrameGenome