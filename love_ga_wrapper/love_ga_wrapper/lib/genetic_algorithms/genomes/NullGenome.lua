local class = require("love_ga_wrapper.lib.classes.class")
local extend = require("love_ga_wrapper.lib.classes.extend")
-------------------------------------------------------------

-- class: NullGenome
-- A null genome
local NullGenome = class(function(self)
end)

-- crossOver: Genome -> NullGenome
-- Returns a new Null Genome
function NullGenome.crossOver(self, genome)
  return NullGenome.new()
end

-- mutate: None -> None
-- Does nothing
function NullGenome.mutate(self)
end

return NullGenome