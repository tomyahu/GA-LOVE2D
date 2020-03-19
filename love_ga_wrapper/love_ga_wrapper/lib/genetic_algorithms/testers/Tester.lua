local class = require("love_ga_wrapper.lib.classes.class")
local extend = require("love_ga_wrapper.lib.classes.extend")
-------------------------------------------------------------

-- class: Tester
-- A tester to get the fitness of individuals in the genetic algorithm
local Tester = class(function(self)
end)

-- test: Individual -> num
-- Returns the fitness value of the current individual
function Tester.test(self, individual)
    return 0
end

return Tester