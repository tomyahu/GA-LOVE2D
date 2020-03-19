local class = require("love_ga_wrapper.lib.classes.class")
local extend = require("love_ga_wrapper.lib.classes.extend")
local FitnessFun = require("love_ga_wrapper.fitness_functions.FitnessFun")
-------------------------------------------------------------

-- class: InputCountFitnessFun
local InputCountFitnessFun = extend(FitnessFun, function(self, input_tracked)
    self.input_tracked = input_tracked
    self.input_number = 0
end)

-- initAux: None -> None
-- The auxiliary initialization function for the fitness calculation, saves the current amount of asteroids
function InputCountFitnessFun.initAux(self)
    self.input_number = 0
end

-- mainFun: None -> num
-- The main fitness function, gets the difference between the current and the asteroid number
function InputCountFitnessFun.mainFun(self)
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
function InputCountFitnessFun.stepFun(self)
end

return InputCountFitnessFun