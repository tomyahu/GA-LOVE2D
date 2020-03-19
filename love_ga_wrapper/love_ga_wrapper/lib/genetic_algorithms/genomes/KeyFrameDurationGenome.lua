local class = require("love_ga_wrapper.lib.classes.class")
local extend = require("love_ga_wrapper.lib.classes.extend")
local KeyFrameGenome = require("love_ga_wrapper.lib.genetic_algorithms.genomes.KeyFrameGenome")
-------------------------------------------------------------

-- class: KeyFrameDurationGenome
-- param: input:str -> the input key to press
-- param: frame:int(1,) -> the frame where to press the input
-- param: frames_duration:int(1,) -> the number of frames the input stays pressed
-- param: word_dict:list(str) -> the word dictionary with all the possible inputs
-- A genome that stores a certain key that was pressed in a certain frame for a number of frames
local KeyFrameDurationGenome = extend(KeyFrameGenome, function(self, input, frame, frames_duration, word_dict)
    if frames_duration < 1 then
      error("KeyFrameDurationGenome's frames elapsed has to be an integer higher than 0, got " .. frames_duration)
    end
    
    self.frames_duration = frames_duration
end,

function(input, frame, frames_duration, word_dict)
  return KeyFrameGenome.new(input, frame, word_dict)
end)

-- durationFrameMutation: int -> None
-- Varies the frame duration where the input was made
function KeyFrameDurationGenome.durationFrameMutation(self, df)
  local random_frame_delta = math.random(-df,df)
  self.frames_duration = math.max(1, self.frames_duration + random_frame_delta)
end

-- mutateWithMaxFrame: int -> None
-- Performs a mutation using an individual's largest frame
-- it performs a dFrame mutation, sets the frame to the set given by max frame
-- then it performs a durationFrame mutation, sets the duration to the set given by max frame
-- and finally it performs a keyChange mutation
function KeyFrameDurationGenome.mutateWithMaxFrame(self, max_frame)
    self:dFrameMutation(10)
    self.frame = math.min(self.frame, max_frame)
    
    self:durationFrameMutation(50)
    self.frames_duration = math.min(self.frames_duration, max_frame - self.frame + 1)
    
    self:keyChangeMutation()
end

-- getter
function KeyFrameDurationGenome.getInputs(self)
  local inputs = {}
  
  if self.active then
      for i= self.frame, (self.frame + self.frames_duration - 1) do
          inputs[i] = self.input
      end
  end
  
  return inputs
end

-- getter
function KeyFrameDurationGenome.getDuration(self)
    return self.frames_duration
end

return KeyFrameDurationGenome