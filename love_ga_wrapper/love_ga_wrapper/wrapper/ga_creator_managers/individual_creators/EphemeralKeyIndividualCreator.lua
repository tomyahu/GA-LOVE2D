local class = require("love_ga_wrapper.lib.classes.class")
local extend = require("love_ga_wrapper.lib.classes.extend")
local SingleKeyIndividualCreator = require("love_ga_wrapper.wrapper.ga_creator_managers.individual_creators.SingleKeyIndividualCreator")
local InputIndividualFactory = require("love_ga_wrapper.lib.genetic_algorithms.individuals.factories.InputIndividualFactory")
--------------------------------------------------------------------------------------------------------

-- class: EphemeralKeyIndividualCreator
-- param: size:int(1,) -> the size of the ephemeral key individual creator
-- creator that makes ephemeral key individuals
local EphemeralKeyIndividualCreator = extend(SingleKeyIndividualCreator ,function(self, size)
    self.size = size
    self.individual_factory = InputIndividualFactory.new({})
end)

-- createRandomIndividual: int(1,) -> EphemeralKeyIndividual
-- creates a random individual
function EphemeralKeyIndividualCreator.createRandomIndividual(self, frames_to_test)
    return self.individual_factory:getRandomEphemeralKeyIndividualWithFramesToTest(self.size, frames_to_test)
end

return EphemeralKeyIndividualCreator
