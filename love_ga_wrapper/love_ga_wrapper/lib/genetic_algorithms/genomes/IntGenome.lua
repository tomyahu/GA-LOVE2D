local class = require("love_ga_wrapper.lib.classes.class")
local extend = require("love_ga_wrapper.lib.classes.extend")
local NullGenome = require("love_ga_wrapper.lib.genetic_algorithms.genomes.NullGenome")
-------------------------------------------------------------

-- class: IntGenome
-- param: integer:int -> the integer of the genome
-- An integer genome
local IntGenome = extend(NullGenome, function(self, integer)
    self.integer = integer
end,

function(integer)
  return NullGenome.new()
end)

-- crossOver: IntGenome -> IntGenome
-- Returns a new Int Genome with the mean of the both the current genome and the genome passed
function IntGenome.crossOver(self, genome)
  local mean = math.floor((self.integer + genome.integer) / 2)
  return IntGenome.new(mean)
end

-- mutate: None -> None
-- Mutates the current genome to a random integer of at most two times the current integer
function IntGenome.mutate(self)
  self.integer = math.random(2*self.integer)
end

return IntGenome