local class = require("love_ga_wrapper.lib.classes.class")
local extend = require("love_ga_wrapper.lib.classes.extend")
local EphemeralKeyGenome = require("love_ga_wrapper.lib.genetic_algorithms.genomes.EphemeralKeyGenome")
-------------------------------------------------------------

-- class: NoInputEphemeralKeyGenome
-- param: input:str -> the input key to press
-- param: frames:int(1,) -> the number of frames the actions will last
-- param: word_dict:list(str) -> the word dictionary with all the possible inputs
-- A genome that stores the no-input key that was pressed for some frames
local NoInputEphemeralKeyGenome = extend(EphemeralKeyGenome,

function(self, frames, word_dict)
end,

function(frames, word_dict)
  return EphemeralKeyGenome.new("no_input", frames, word_dict)
end)

-- keyChangeMutation: None -> None
-- Does Nothing
function NoInputEphemeralKeyGenome.keyChangeMutation(self) end

return NoInputEphemeralKeyGenome