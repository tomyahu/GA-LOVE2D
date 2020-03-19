local class = require("love_ga_wrapper.lib.classes.class")
local extend = require("love_ga_wrapper.lib.classes.extend")
--------------------------------------------------------------------------------------------------------

-- class: DictFile
-- param: path:str -> the path of the file serving as a dictionary
-- An object to manage files that contain dictionaries
local DictFile = class(function(self, path)
    self.path = path
    self.dict = {}
end)

-- setter
function DictFile.setDict(self, dict)
    self.dict = dict
end

-- getter
function DictFile.getDict(self)
    return self.dict
end

-- set: any, any -> None
-- sets a key to a value in the dictionary
function DictFile.set(self, key, value)
    self.dict[key] = value
end

-- get: any -> any
-- gets the value asociated with a key in the dictionary
function DictFile.get(self, key)
    return self.dict[key]
end

-- load: None -> None
-- loads the dictionary in the file in the local field
function DictFile.load(self) end

-- save: None -> None
-- saves the dictionary field in the file
function DictFile.save(self) end

return DictFile