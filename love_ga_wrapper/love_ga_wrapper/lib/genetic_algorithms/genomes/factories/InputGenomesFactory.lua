local class = require("love_ga_wrapper.lib.classes.class")
local extend = require("love_ga_wrapper.lib.classes.extend")
local SingleInputKeyGenome = require("love_ga_wrapper.lib.genetic_algorithms.genomes.SingleInputKeyGenome")
local KeyFrameGenome = require("love_ga_wrapper.lib.genetic_algorithms.genomes.KeyFrameGenome")
local KeyFrameDurationGenome = require("love_ga_wrapper.lib.genetic_algorithms.genomes.KeyFrameDurationGenome")
local EphemeralKeyGenome = require("love_ga_wrapper.lib.genetic_algorithms.genomes.EphemeralKeyGenome")
local NoInputEphemeralKeyGenome = require("love_ga_wrapper.lib.genetic_algorithms.genomes.NoInputEphemeralKeyGenome")
-------------------------------------------------------------

-- class: InputGenomesFactory
-- param: input_dict:list(str) -> a list with the words corresponding to posible inputs
-- a factory class to create genomes of certain types
local InputGenomesFactory = class(function(self, input_dict)
    self.input_dict = input_dict
end)

-- getRandomNoInputEphemeralKeyGenome: int(1,) -> NoInputEphemeralKeyGenome
-- returns a random (in frame number) ephemeral key genome with null input.
function InputGenomesFactory.getRandomNoInputEphemeralKeyGenome(self, max_frames)
    local random_amount_of_frames = math.random(1, max_frames)
    return NoInputEphemeralKeyGenome.new(random_amount_of_frames, self.input_dict)
end

-- getRandomEphemeralKeyGenome: int(1,) -> EphemeralKeyGenome
-- returns a random (in input and frame number) ephemeral key genome
function InputGenomesFactory.getRandomEphemeralKeyGenome(self, max_frames)
    local random_input = self.input_dict[math.random((# self.input_dict))]
    local random_amount_of_frames = math.random(1, max_frames)
    return EphemeralKeyGenome.new(random_input, random_amount_of_frames, self.input_dict)
end

-- getRandomKeyFrameDurationGenome: int(1,), int(1,) -> KeyFrameDurationGenome
-- returns a random (in input, frame and duration) key frame duration genome
function InputGenomesFactory.getRandomKeyFrameDurationGenome(self, max_frame, max_duration)
    local random_input = self.input_dict[math.random((# self.input_dict))]
    local random_frame = math.random(1, max_frame)
    local random_duration = math.random(1, max_duration)
    random_duration = math.max(math.min(max_frame - random_frame, random_duration), 1)
    
    return KeyFrameDurationGenome.new(random_input, random_frame, random_duration, self.input_dict)
end

-- getRandomKeyFrameGenome: int(1,) -> KeyFrameGenome
-- returns a random (in input and frame) key frame genome
function InputGenomesFactory.getRandomKeyFrameGenome(self, max_frame)
    local random_input = self.input_dict[math.random((# self.input_dict))]
    local random_frame = math.random(1, max_frame)
    return KeyFrameGenome.new(random_input, random_frame, self.input_dict)
end

-- getRandomSingleInputKeyGenome: None -> SingleInputKeyGenome
-- returns a random single input key genome
function InputGenomesFactory.getRandomSingleInputKeyGenome(self)
  local random_input = self.input_dict[math.random((# self.input_dict))]
  return SingleInputKeyGenome.new(random_input, self.input_dict)
end

-- getEmptySingleInputKeyGenome: None -> SingleInputKeyGenome
-- returns an empty single input key genome
function InputGenomesFactory.getEmptySingleInputKeyGenome(self)
  local empty_input = self.input_dict[1]
  return SingleInputKeyGenome.new(empty_input, self.input_dict)
end

-- setter
function InputGenomesFactory.setInputDict(self, new_input_dict)
    self.input_dict = new_input_dict
end

return InputGenomesFactory