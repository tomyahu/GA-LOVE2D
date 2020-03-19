local class = require("love_ga_wrapper.lib.classes.class")
local extend = require("love_ga_wrapper.lib.classes.extend")
--------------------------------------------------------------------------------------------------------

-- class: SelectionFunction
-- Dummy selection function that always returns the first individual of the population
local SelectionFunction = class(function(self)

end)

-- select: Population -> Individual
-- Selects an individual, in this case it always selects the first individual of the population
function SelectionFunction.select(self, population)
    local individuals = population:getIndividuals()
    return individuals[1]
end

return SelectionFunction
