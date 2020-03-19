local class = require("love_ga_wrapper.lib.classes.class")
local extend = require("love_ga_wrapper.lib.classes.extend")
-------------------------------------------------------------

-- class: FitnessFun
local FitnessFun = class(function(self)
    self.individual_tas = nil
end)

-- setLoveGACreator: LoveGACreator -> None
-- setter
function FitnessFun.setLoveGACreator(self, love_ga_creator)
  self.love_ga_creator = love_ga_creator
end

-- init: TASInput -> None
-- The initialization function for the fitness calculation
function FitnessFun.init(self, individual_tas)
    self.individual_tas = individual_tas
    self:initAux()
end

-- init: None -> None
-- The auxiliary initialization function for the fitness calculation
function FitnessFun.initAux(self)    
end

-- mainFun: None -> num
-- The main fitness function
function FitnessFun.mainFun(self)
  return 0
end

-- stepFun: None -> None
-- The step fitness function
function FitnessFun.stepFun(self)
end

return FitnessFun