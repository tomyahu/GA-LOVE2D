local class = require("love_ga_wrapper.lib.classes.class")
local extend = require("love_ga_wrapper.lib.classes.extend")
-------------------------------------------------------------

-- class: NullTASInput
-- A type of TAS that always returns an empty input list
local NullTASInput = class(function(self)
    self.inputs = {}
end)

-- addPressed: int, str -> None
-- adds an input to make on a frame
function NullTASInput.addPressed(self, frame_num, input)
  self.inputs[frame_num] = input
end

-- getInputsFromFrame: int -> list(str)
-- get all the inputs to press on a frame 
function NullTASInput.getInputsFromFrame(self, frame)
  local input_list = {}
  return input_list
end

-- getter
function NullTASInput.getInputs(self)
    return self.inputs
end

return NullTASInput