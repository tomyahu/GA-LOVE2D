local class = require("love_ga_wrapper.lib.classes.class")
local extend = require("love_ga_wrapper.lib.classes.extend")
local SingleKeyIndividualCreator = require("love_ga_wrapper.wrapper.ga_creator_managers.individual_creators.SingleKeyIndividualCreator")
--------------------------------------------------------------------------------------------------------

-- class: IndividualManager
-- param: frames_to_test:int(1,) -> the amount of frames to test
-- param: ga_creator:LoveGACreator -> the wrapper that runs the genetic algorithm
-- manager class that creates the initial individuals for the genetic algorithm
local IndividualManager = class(function(self, frames_to_test, ga_creator)
    self.frames_to_test = frames_to_test
    self.ga_creator = ga_creator

    -- Create default individual creator
    self.individual_creator = SingleKeyIndividualCreator.new(1)
end)

-- createRandomIndividual: None -> Individual
-- creates a random individdual given the individual creator
function IndividualManager.createRandomIndividual(self)
    return self.individual_creator:createRandomIndividual(self.frames_to_test)
end

-- setters
function IndividualManager.setFramesToTest(self, new_frames_to_test)
    self.frames_to_test = new_frames_to_test
end

function IndividualManager.setIndividualCreator(self, new_individual_creator)
    self.individual_creator = new_individual_creator
    new_individual_creator:setWordDict(self.ga_creator:getInputList())
end

-- getters
function IndividualManager.getIndividualCreator(self)
    return self.individual_creator
end

return IndividualManager
