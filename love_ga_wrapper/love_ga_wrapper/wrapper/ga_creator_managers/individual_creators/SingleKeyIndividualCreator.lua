local class = require("love_ga_wrapper.lib.classes.class")
local extend = require("love_ga_wrapper.lib.classes.extend")
local InputIndividualFactory = require("love_ga_wrapper.lib.genetic_algorithms.individuals.factories.InputIndividualFactory")
--------------------------------------------------------------------------------------------------------

-- class: SingleKeyIndividualCreator
-- param: size:int(1,) -> the size of the single key individual creator
-- creator that makes single key individuals
local SingleKeyIndividualCreator = class(function(self, size)
    self.size = size
    self.individual_factory = InputIndividualFactory.new({})
end)

-- createRandomIndividual: int(1,) -> InputKeyIndividual
-- creates a random individual
function SingleKeyIndividualCreator.createRandomIndividual(self, frames_to_test)
    return self.individual_factory:getRandomInputSingleKeyIndividual(self.size)
end

-- setters
function SingleKeyIndividualCreator.setIndividualFactory(self, new_individual_factory)
    self.individual_factory = new_individual_factory
end

function SingleKeyIndividualCreator.setWordDict(self, new_word_dict)
    self.individual_factory:setWordDict(new_word_dict)
end

return SingleKeyIndividualCreator
