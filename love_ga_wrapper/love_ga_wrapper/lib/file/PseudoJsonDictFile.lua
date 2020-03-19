local class = require("love_ga_wrapper.lib.classes.class")
local extend = require("love_ga_wrapper.lib.classes.extend")
local pseudo_json = require("love_ga_wrapper.lib.file.pseudo_json.pseudo_json")
local DictFile = require("love_ga_wrapper.lib.file.DictFile")
--------------------------------------------------------------------------------------------------------

-- class: PseudoJsonDictFile
-- param: path:str -> the path of the file serving as a dictionary
-- An object to manage json files that contain dictionaries
local PseudoJsonDictFile = extend(DictFile, function(self, path)
end,

function(path)
    return DictFile.new(path)
end)

-- load: None -> None
-- loads the dictionary in the file in the local field
function PseudoJsonDictFile.load(self)
    local file = io.open(self.path, "r")
    self.dict = pseudo_json.decode(file:read())
    file:close()
end

-- save: None -> None
-- saves the dictionary field in the file
function PseudoJsonDictFile.save(self)
    local file = io.open(self.path, "w")
    file:write(pseudo_json.encode(self.dict))
    file:close()
end

return PseudoJsonDictFile