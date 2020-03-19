local class = require("love_ga_wrapper.lib.classes.class")
local extend = require("love_ga_wrapper.lib.classes.extend")
--------------------------------------------------------------------------------------------------------

-- class: MutationFunction
-- An empty class (interface) for mutation functions
local MutationFunction = class(function(self)
    
end)

-- mutate: Individual -> None
-- mutates an individual, in this case oit does nothing
function MutationFunction.mutate(self, individual)

end

return MutationFunction
