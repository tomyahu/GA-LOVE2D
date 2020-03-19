local class = require("love_ga_wrapper.lib.classes.class")
local extend = require("love_ga_wrapper.lib.classes.extend")
local NullGenome = require("love_ga_wrapper.lib.genetic_algorithms.genomes.NullGenome")
-------------------------------------------------------------
local word_dict = {"a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"," "}

-- class: CharGenome
-- param: char:str -> a character from the word dict
-- An character genome
local CharGenome = extend(NullGenome, function(self, char)
    self.char = char
end,

function(char)
  return NullGenome.new()
end)

-- crossOver: CharGenome -> CharGenome
-- Returns a new Char Genome with a characcter chosen at random between the two
function CharGenome.crossOver(self, genome)
  local new_char = ''
  
  if math.random() < 0.5 then
    new_char = self.char
  else
    new_char = genome.char
  end
  
  return CharGenome.new(new_char)
end

-- mutate: None -> None
-- Mutates the current genome, changes the character of this genome to a random character
function CharGenome.mutate(self)
  self.char = word_dict[math.random(# word_dict)]
end

-- getter
function CharGenome.getChar(self)
  return self.char
end

return CharGenome