local class = require("love_ga_wrapper.lib.classes.class")
local extend = require("love_ga_wrapper.lib.classes.extend")
local Individual = require("love_ga_wrapper.lib.genetic_algorithms.individuals.Individual")
-------------------------------------------------------------

-- class: InputIndividual
-- param: genomes:list(Genome) -> The list of genomes of the curren individual
-- An input individual in the genetic algorithm, represents an input script, the base class for every individual that
-- represents an inut script
local InputIndividual = extend(Individual, function(self, genomes)

end)

-- getInputsOnFrame: int(1,) -> dict(str,bool)
-- Gets this individual's inputs given a frame
function InputIndividual.getInputsOnFrame(self, frame)
end

-- getInputs: None -> list(dict(str, bool))
-- Gets the complete list of this individual's inputs
function InputIndividual.getInputs(self)
end

-- getClass: None -> class
-- Returns the class of the Input Individual
function InputIndividual.getClass(self)
    return InputIndividual
end

return InputIndividual