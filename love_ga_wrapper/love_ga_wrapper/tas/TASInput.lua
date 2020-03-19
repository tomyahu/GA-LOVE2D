local class = require("love_ga_wrapper.lib.classes.class")
local extend = require("love_ga_wrapper.lib.classes.extend")
local NullTASInput = require("love_ga_wrapper.tas.NullTASInput")
-------------------------------------------------------------

-- class: TASInput
-- A type of TAS Input that returns an array of inputs for every frame using a dictionary
local TASInput = extend(NullTASInput, function(self)
end,
    function()
        return NullTASInput.new()
    end)

-- setInputs: dict -> None
-- define the internal dictionary inputs
function TASInput.setInputs(self, dict)
    self.inputs = dict
end

-- getInputsFromFrame: int -> list(str)
-- get all the inputs to press on a frame 
function TASInput.getInputsFromFrame(self, frame)
    local inputs = self.inputs[frame]

    if inputs == nil then
        inputs = {}
    end

    return inputs
end

-- getInputsFromIndividual: Individual -> dict(int, tuple(str, bool))
-- gets the intputs from an individual
function TASInput.getInputsFromIndividual(self, individual)
    self.inputs = individual:getInputs()
end

-- getter
function TASInput.getInputs(self)
    return self.inputs
end

-- setter
function TASInput.setInputs(self, new_inputs)
    self.inputs = new_inputs
end

return TASInput
