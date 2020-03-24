local class = require("love_ga_wrapper.lib.classes.class")
local extend = require("love_ga_wrapper.lib.classes.extend")
local FitnessFun = require("love_ga_wrapper.fitness_functions.FitnessFun")
-------------------------------------------------------------

-- class: InputPressFitnessFun
-- param: input_tracked:str -> the type of input tracked
-- a fitness function that counts how many times an input was activated in an individual (this just counts the button
-- presses, it doesn't count the releases and holds)
local InputPressFitnessFun = extend(FitnessFun, function(self, input_tracked)
    self.input_tracked = input_tracked
    self.input_number = 0
end)

-- initAux: None -> None
-- The auxiliary initialization function for the fitness calculation, resets the input number
function InputPressFitnessFun.initAux(self)
    self.input_number = 0
end

-- mainFun: None -> num
-- The main fitness function, gets all the times the assigned input was pressed
function InputPressFitnessFun.mainFun(self)
    local tas_inputs = self.individual_tas:getInputs()
    
    for frame, inputs_in_frame in pairs(tas_inputs) do
        if inputs_in_frame[self.input_tracked] then
            self.input_number = self.input_number + 1
        end
    end
    
    return self.input_number
end

-- stepFun: None -> None
-- The step fitness function, does nothing
function InputPressFitnessFun.stepFun(self)
end

return InputPressFitnessFun