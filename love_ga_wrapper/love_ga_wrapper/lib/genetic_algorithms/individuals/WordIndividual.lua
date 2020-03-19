local class = require("love_ga_wrapper.lib.classes.class")
local extend = require("love_ga_wrapper.lib.classes.extend")
local Individual = require("love_ga_wrapper.lib.genetic_algorithms.individuals.Individual")
-------------------------------------------------------------

-- class: WordIndividual
-- param: genomes:list(CharGenome) -> The list of genomes of the curren individual
-- An individual in the genetic algorithm, represents a string
local WordIndividual = extend(Individual, function(self, genomes)
    
end,

function(genomes)
  return Individual.new(genomes)
end
)

-- getWord: None -> str
-- Gets this individual's word
function WordIndividual.getWord(self)
  local word = ""
  for i=1,(# self.genomes) do
    word = word .. self.genomes[i]:getChar()
  end
  return word
end

-- getClass: None -> class
-- Returns the class of the Word Individual
function WordIndividual.getClass(self)
  return WordIndividual
end

return WordIndividual