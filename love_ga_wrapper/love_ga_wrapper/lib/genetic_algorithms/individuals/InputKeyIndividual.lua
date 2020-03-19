local class = require("love_ga_wrapper.lib.classes.class")
local extend = require("love_ga_wrapper.lib.classes.extend")
local InputIndividual = require("love_ga_wrapper.lib.genetic_algorithms.individuals.InputIndividual")
-------------------------------------------------------------

-- class: InputKeyIndividual
-- param: genomes:list(SingleInputKeyGenome) -> The list of genomes of the curren individual
-- An individual in the genetic algorithm
local InputKeyIndividual = extend(InputIndividual, function(self, genomes)

end)

-- getInputsOnFrame: int(1,) -> dict(str,bool)
-- Gets this individual's inputs given a frame
function InputKeyIndividual.getInputsOnFrame(self, frame)
    return self.genomes[frame]:getInputs()
end

-- getInputs: None -> list(dict(str, bool))
-- Gets the complete list of this individual's inputs
function InputKeyIndividual.getInputs(self)
    local inputs = {}
    inputs[1] = {}
    for i = 1, (# self.genomes) do
        local genome_inputs = self.genomes[i]:getInputs()

        inputs[i+1] = {}

        for input, status in pairs(genome_inputs) do
            inputs[i][input] = status
            if status then
                inputs[i+1][input] = false
            end
        end
    end
    return inputs
end

-- getClass: None -> class
-- Returns the class of the Input Key Individual
function InputKeyIndividual.getClass(self)
    return InputKeyIndividual
end

return InputKeyIndividual